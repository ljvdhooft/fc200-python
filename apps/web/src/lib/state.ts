import { derived, get, writable } from "svelte/store";
import type { Connection, LinkStatus } from "./connection";

/** The state tree of protocol/frontend.md section 3. Fields are optional: missing == null. */
export interface FcState {
  version?: string;
  page?: number;
  mode?: string;
  tempo?: number;
  pedalboard?: { found: boolean; track?: string; track_index?: number; device?: string; device_index?: number };
  transport?: { playing: boolean; metronome: boolean };
  scenes?: Record<string, unknown>;
  loops?: unknown[];
  edit?: Record<string, unknown>;
  presets?: Record<string, unknown>;
  hub?: { live_connected: boolean };
  [key: string]: unknown;
}

export type Changes = Record<string, unknown>;

type Container = Record<string, unknown> | unknown[];

const clone = <T>(v: T): T => structuredClone(v);

/**
 * Apply `state.changed` in place; mirrors apply_changes in src/ui_protocol.py.
 * Paths are dotted, lists are indexed by number, null deletes an object key
 * (but stays in a list, so indices don't shift). A path whose parent is
 * missing is ignored (logged); the next dump resyncs.
 */
export function applyChanges(state: FcState, changes: Changes): void {
  const paths = Object.keys(changes).sort((a, b) => a.split(".").length - b.split(".").length);
  for (const path of paths) {
    const segs = path.split(".");
    const last = segs.pop()!;
    let node: unknown = state;
    for (const s of segs) {
      node = (node as Container | undefined)?.[s as never];
      if (node === undefined || node === null || typeof node !== "object") break;
    }
    if (node === undefined || node === null || typeof node !== "object") {
      console.warn("state.changed: unknown parent for", path);
      continue;
    }
    const value = clone(changes[path]);
    if (Array.isArray(node)) {
      const i = Number(last);
      if (!Number.isInteger(i) || i < 0 || i > node.length || (i === node.length && value === null)) {
        console.warn("state.changed: bad list index in", path);
        continue;
      }
      node[i] = value;
    } else if (value === null) {
      delete (node as Record<string, unknown>)[last];
    } else {
      (node as Record<string, unknown>)[last] = value;
    }
  }
}

export const appState = writable<FcState>({});
export const link = writable<LinkStatus>("closed");
/** True once the first dump has arrived on the current connection. */
export const synced = writable(false);

export const liveConnected = derived(appState, ($s) => $s.hub?.live_connected === true);

export type Health = "live" | "reconnecting" | "offline";
/** live: hub and Live up; reconnecting: hub unreachable or no dump yet; offline: hub up but Live down. */
export const health = derived([link, synced, liveConnected], ([$link, $synced, $live]): Health => {
  if ($link === "open" && $synced) return $live ? "live" : "offline";
  return "reconnecting";
});

export function applyDump(dump: FcState): void {
  appState.set(clone(dump));
  synced.set(true);
}

export function applyStateChanged(changes: Changes): void {
  appState.update((s) => {
    const next = clone(s);
    applyChanges(next, changes);
    return next;
  });
}

export function bind(conn: Connection): void {
  conn.onStatus((s) => {
    link.set(s);
    if (s !== "open") synced.set(false);
  });
  conn.on("state.dump", (d) => applyDump(d as FcState));
  conn.on("state.changed", (d) => applyStateChanged(d as Changes));
  conn.on("hub.status", (d) => {
    const live = (d as { live_connected: boolean }).live_connected;
    appState.update((s) => ({ ...s, hub: { live_connected: live } }));
  });
}

export const snapshot = (): FcState => get(appState);
