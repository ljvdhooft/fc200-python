import unittest

import support  # noqa: F401
from fc200.listeners import Listeners  # noqa: E402


class FakeSubject:
    """Mimics Live's add_/remove_/has_ listener methods for property 'value'."""

    def __init__(self):
        self.callbacks = []

    def add_value_listener(self, f):
        self.callbacks.append(f)

    def remove_value_listener(self, f):
        self.callbacks.remove(f)

    def value_has_listener(self, f):
        return f in self.callbacks

    def fire(self):
        for f in list(self.callbacks):
            f()


class ListenersTest(unittest.TestCase):
    def setUp(self):
        self.log = []
        self.listeners = Listeners(self.log.append)

    def test_add_and_fire(self):
        subject, calls = FakeSubject(), []
        self.listeners.add(subject, "value", lambda: calls.append(1))
        subject.fire()
        self.assertEqual(calls, [1])
        self.assertEqual(len(self.listeners), 1)

    def test_remove_all(self):
        a, b = FakeSubject(), FakeSubject()
        self.listeners.add(a, "value", lambda: None)
        self.listeners.add(b, "value", lambda: None)
        self.listeners.remove_all()
        self.assertEqual((a.callbacks, b.callbacks), ([], []))
        self.assertEqual(len(self.listeners), 0)

    def test_remove_all_tolerates_already_removed(self):
        subject = FakeSubject()
        self.listeners.add(subject, "value", lambda: None)
        subject.callbacks.clear()
        self.listeners.remove_all()

    def test_same_callback_twice_is_two_listeners(self):
        subject, calls = FakeSubject(), []
        callback = lambda: calls.append(1)  # noqa: E731
        self.listeners.add(subject, "value", callback)
        self.listeners.add(subject, "value", callback)
        subject.fire()
        self.assertEqual(calls, [1, 1])

    def test_exception_is_logged_and_listener_keeps_working(self):
        subject, calls = FakeSubject(), []

        def callback():
            calls.append(1)
            raise RuntimeError("boom")
        self.listeners.add(subject, "value", callback)
        subject.fire()
        subject.fire()
        self.assertEqual(calls, [1, 1])
        self.assertEqual(len(self.log), 2)
        self.assertIn("RuntimeError: boom", self.log[0])
        self.assertIn("value listener", self.log[0])


if __name__ == "__main__":
    unittest.main()
