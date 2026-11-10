import itertools

from _Framework import Task
from . import fc200_protocol as fc


class FC200Hardware:
    """LEDs and 7-segment display of the FC200, driven over SysEx."""

    def __init__(self, send_midi, tasks, log=None):
        self._send_midi = send_midi
        self._tasks = tasks
        self._log = log
        self._restore_task = None

    def send(self, body):
        msg = fc.build(body)
        if self._log:
            self._log(f"\nsending out: {msg}")
        self._send_midi(msg)

    def led(self, pedal, value):
        self.send([fc.BANK_LED, pedal, value])

    def leds_off(self):
        for pedal in range(0, 9 + 1):
            self.led(pedal, fc.OFF)

    def flash(self, pedal):
        self.led(pedal, fc.ON)
        self._tasks.add(Task.sequence(
            Task.wait(0.1),
            Task.run(lambda: self.led(pedal, fc.OFF))
        ))

    def blink(self, pedal, interval):
        """Blink one LED until the returned task is killed."""
        values = itertools.cycle((fc.ON, fc.OFF))
        return self._tasks.add(Task.loop(Task.sequence(
            Task.wait(interval),
            Task.run(lambda: self.led(pedal, next(values)))
        )))

    def display_raw(self, digit, binary):
        self.send([fc.BANK_DISPLAY, digit, binary])

    def display(self, digit, char):
        self.display_raw(digit, fc.segments(char))

    def show(self, left, right):
        self.display(fc.DISPLAY_LEFT, left)
        self.display(fc.DISPLAY_RIGHT, right)

    def show_temporarily(self, left, right, restore, timeout=1):
        """Show two raw bitmasks, then call restore() after timeout seconds.

        A newer call replaces a pending restore.
        """
        if self._restore_task is not None:
            self._restore_task.kill()
        self.display_raw(fc.DISPLAY_LEFT, left)
        self.display_raw(fc.DISPLAY_RIGHT, right)
        self._restore_task = self._tasks.add(Task.sequence(
            Task.wait(timeout),
            Task.run(restore)
        ))
