"""Wire format and state replication shared by the Remote Script and the hub.

Messages are JSON objects, one per line:
  request   {"id", "method", "params"}
  response  {"id", "result"} or {"id", "error": {"code", "message"}}
  event     {"event", "data"}

StateModel is the producer's nested dict. Writers call set() with dotted paths
("loops.2.favorite.value"; an integer segment indexes a list). The model records
which paths changed, and flush() turns them into one patch {path: value} that
apply_patch() applies to a receiver's copy. Patch rules:
  - an unchanged value is never dirty;
  - when a list's length changes, the whole list is sent under its own path;
  - a value of null deletes the key.

No Live imports and stdlib only: this runs inside Live (Python 3.11) and in the
external hub.
"""

from __future__ import annotations

import copy
import json
from typing import Any

Message = dict[str, Any]
Patch = dict[str, Any]


class ProtocolError(ValueError):
    """A line that is not a valid message."""


def encode(message: Message) -> bytes:
    """One message as a UTF-8 JSON line, including the trailing newline."""
    return json.dumps(message, separators=(",", ":")).encode("utf-8") + b"\n"


def decode(line: bytes | str) -> Message:
    """Parse one line; raises ProtocolError unless it is a request, response or event."""
    try:
        message = json.loads(line)
    except (ValueError, UnicodeDecodeError) as e:
        raise ProtocolError(f"invalid JSON: {e}") from e
    if not isinstance(message, dict):
        raise ProtocolError("message is not an object")
    if "event" in message:
        if not isinstance(message["event"], str):
            raise ProtocolError("event name is not a string")
    elif "id" in message:
        if "method" in message:
            if not isinstance(message["method"], str):
                raise ProtocolError("method is not a string")
            if not isinstance(message.get("params", {}), dict):
                raise ProtocolError("params is not an object")
        elif "result" not in message and "error" not in message:
            raise ProtocolError("response has neither result nor error")
    else:
        raise ProtocolError("message has no id or event")
    return message


def request(id: int | str, method: str, params: dict[str, Any] | None = None) -> Message:
    return {"id": id, "method": method, "params": params or {}}


def response(id: int | str, result: Any = None) -> Message:
    return {"id": id, "result": result}


def error_response(id: int | str | None, code: str, message: str) -> Message:
    return {"id": id, "error": {"code": code, "message": message}}


def event(name: str, data: Any = None) -> Message:
    return {"event": name, "data": data}


def _same(a: Any, b: Any) -> bool:
    # json.dumps keeps True and 1 apart, which == does not
    return json.dumps(a, sort_keys=True) == json.dumps(b, sort_keys=True)


def _child(container: Any, segment: str) -> Any:
    """The value at one path segment; KeyError/IndexError when absent."""
    if isinstance(container, list):
        return container[int(segment)]
    return container[segment]


def _walk(state: Any, segments: list[str], create: bool) -> Any:
    """Follow segments from state, optionally creating missing dicts."""
    node = state
    for segment in segments:
        try:
            node = _child(node, segment)
        except (KeyError, IndexError):
            if not create or isinstance(node, list):
                raise
            node[segment] = node = {}
    return node


def _assign(state: dict[str, Any], path: str, value: Any) -> bool:
    """Set or delete the value at path. Returns True if a list grew or shrank."""
    *parents, last = path.split(".")
    parent = _walk(state, parents, create=True)
    if isinstance(parent, list):
        i = int(last)
        if i == len(parent) and value is not None:
            parent.append(value)
            return True
        parent[i] = value  # null stays in a list: indices must not shift
    elif value is None:
        parent.pop(last, None)
    else:
        parent[last] = value
    return False


class StateModel:
    def __init__(self, initial: dict[str, Any] | None = None) -> None:
        self._state: dict[str, Any] = copy.deepcopy(initial) if initial else {}
        self._dirty: set[str] = set()

    def get(self, path: str, default: Any = None) -> Any:
        try:
            return _walk(self._state, path.split("."), create=False)
        except (KeyError, IndexError, ValueError):
            return default

    def set(self, path: str, value: Any) -> None:
        """Set the value at path (None deletes it); dirty only if it differs."""
        if _same(self.get(path), value):
            return
        value = copy.deepcopy(value)
        if _assign(self._state, path, value):
            # An append changes the list length: send the whole list
            path = path.rpartition(".")[0]
        self._dirty.add(path)

    def snapshot(self) -> dict[str, Any]:
        """A deep copy of the whole state, for a client that just connected."""
        return copy.deepcopy(self._state)

    def flush(self) -> Patch | None:
        """The changes since the last flush as {path: value}, or None if there are none."""
        if not self._dirty:
            return None
        paths = sorted(self._dirty, key=lambda p: p.count("."))
        self._dirty.clear()
        patch: Patch = {}
        for path in paths:
            # A changed ancestor already carries this value
            if any(path.startswith(sent + ".") for sent in patch):
                continue
            patch[path] = copy.deepcopy(self.get(path))
        return patch


def apply_patch(state: dict[str, Any], patch: Patch) -> None:
    """Apply a flushed patch to a receiver's state, in place."""
    for path in sorted(patch, key=lambda p: p.count(".")):
        _assign(state, path, copy.deepcopy(patch[path]))
