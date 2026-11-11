import json
import socket
import time
import unittest

import support  # noqa: F401
from fc200 import ui_protocol as proto  # noqa: E402
from fc200.ui_gateway import MethodError, UiGateway  # noqa: E402


class Client:
    """A blocking test client; read() polls the gateway until a line arrives."""

    def __init__(self, gateway):
        self.gateway = gateway
        self.sock = socket.create_connection(("127.0.0.1", gateway.port))
        self.sock.settimeout(0.01)
        self.buffer = b""

    def send(self, message):
        self.sock.sendall(proto.encode(message))

    def read(self):
        deadline = time.monotonic() + 2
        while b"\n" not in self.buffer:
            self.assert_before(deadline)
            self.gateway.poll()
            try:
                self.buffer += self.sock.recv(65536)
            except socket.timeout:
                pass
        line, self.buffer = self.buffer.split(b"\n", 1)
        return json.loads(line)

    def nothing_more(self):
        for _ in range(5):
            self.gateway.poll()
            try:
                data = self.sock.recv(65536)
            except socket.timeout:
                continue
            raise AssertionError(f"unexpected data: {data!r}")

    @staticmethod
    def assert_before(deadline):
        if time.monotonic() > deadline:
            raise AssertionError("no message from the gateway")


class UiGatewayTest(unittest.TestCase):
    def setUp(self):
        self.model = proto.StateModel({"tempo": 120.0, "page": 1})
        self.logs = []

        def fail(params):
            raise MethodError("not_found", "no such loop")

        def crash(params):
            raise RuntimeError("boom")

        self.gateway = UiGateway(self.model, {
            "echo": lambda params: params,
            "fail": fail,
            "crash": crash,
        }, self.logs.append, port=0)
        self.clients = []

    def tearDown(self):
        for client in self.clients:
            client.sock.close()
        self.gateway.close()

    def connect(self):
        client = Client(self.gateway)
        self.clients.append(client)
        return client

    def test_snapshot_on_connect(self):
        client = self.connect()
        self.assertEqual(client.read(), {"event": "state.snapshot",
                                         "data": {"tempo": 120.0, "page": 1}})

    def test_patch_is_sent_to_every_client_once_per_poll(self):
        a, b = self.connect(), self.connect()
        a.read(), b.read()
        self.model.set("tempo", 90.0)
        self.model.set("tempo", 95.0)
        expected = {"event": "state.patch", "data": {"tempo": 95.0}}
        self.assertEqual(a.read(), expected)
        self.assertEqual(b.read(), expected)
        a.nothing_more()

    def test_new_client_gets_pending_changes_in_its_snapshot(self):
        self.model.set("tempo", 90.0)
        client = self.connect()
        self.assertEqual(client.read()["data"]["tempo"], 90.0)

    def test_request_and_response(self):
        client = self.connect()
        client.read()
        client.send(proto.request(7, "echo", {"x": 1}))
        self.assertEqual(client.read(), {"id": 7, "result": {"x": 1}})

    def test_params_default_to_empty(self):
        client = self.connect()
        client.read()
        client.send({"id": 1, "method": "echo"})
        self.assertEqual(client.read(), {"id": 1, "result": {}})

    def test_method_error(self):
        client = self.connect()
        client.read()
        client.send(proto.request("a", "fail"))
        self.assertEqual(client.read(), {"id": "a", "error": {"code": "not_found",
                                                              "message": "no such loop"}})

    def test_handler_exception_is_logged_and_answered(self):
        client = self.connect()
        client.read()
        client.send(proto.request(1, "crash"))
        self.assertEqual(client.read()["error"]["code"], "internal")
        self.assertIn("RuntimeError: boom", self.logs[-1])
        # The gateway keeps working
        client.send(proto.request(2, "echo"))
        self.assertEqual(client.read(), {"id": 2, "result": {}})

    def test_unknown_method(self):
        client = self.connect()
        client.read()
        client.send(proto.request(1, "nope"))
        self.assertEqual(client.read()["error"]["code"], "unknown_method")

    def test_bad_line(self):
        client = self.connect()
        client.read()
        client.sock.sendall(b"not json\n")
        self.assertEqual(client.read()["error"]["code"], "bad_params")

    def test_events_from_a_client_are_ignored(self):
        client = self.connect()
        client.read()
        client.send(proto.event("hello"))
        client.nothing_more()

    def test_request_split_over_two_sends(self):
        client = self.connect()
        client.read()
        line = proto.encode(proto.request(1, "echo"))
        client.sock.sendall(line[:5])
        self.gateway.poll()
        client.sock.sendall(line[5:])
        self.assertEqual(client.read(), {"id": 1, "result": {}})

    def test_disconnected_client_is_dropped(self):
        a, b = self.connect(), self.connect()
        a.read(), b.read()
        a.sock.close()
        self.clients.remove(a)
        self.model.set("tempo", 80.0)
        self.assertEqual(b.read()["data"], {"tempo": 80.0})
        # The close may only be seen on a later poll
        deadline = time.monotonic() + 2
        while len(self.gateway._clients) > 1:
            Client.assert_before(deadline)
            self.gateway.poll()

    def test_port_taken_disables_the_gateway(self):
        other = UiGateway(self.model, {}, self.logs.append, port=self.gateway.port)
        self.assertIsNone(other.port)
        self.assertIn("disabled", self.logs[-1])
        other.poll()

    def test_close_releases_the_port(self):
        port = self.gateway.port
        self.gateway.close()
        again = UiGateway(self.model, {}, self.logs.append, port=port)
        self.assertEqual(again.port, port)
        again.close()


if __name__ == "__main__":
    unittest.main()
