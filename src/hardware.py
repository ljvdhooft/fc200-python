import itertools

from _Framework import Task
from . import roland_exclusive as se


class FC200Hardware:
    """LEDs, bank display and mode of the FC-200, driven over Roland Exclusive."""

    def __init__(self, send_midi, tasks, log=None):
        self._send_midi = send_midi
        self._tasks = tasks
        self._log = log
        self._bank_display = (se.segments(' '), se.segments(' '))
        self._restore_task = None

    def send(self, body):
        msg = se.build(body)
        if self._log:
            self._log(f"\nsending out: {msg}")
        self._send_midi(msg)

    def force_exclusive_mode(self, body):
        """Switch back to Exclusive Mode if the FC-200 reports another mode.

        Return True if it switched.
        """
        if body[:2] != [se.Area.MODE_STATUS, se.MODE_CURRENT] or body[2] == se.MODE_EXCLUSIVE:
            return False
        self.send([se.Area.MODE_STATUS, se.MODE_SET, se.MODE_EXCLUSIVE])
        return True

    def led(self, pedal, value):
        self.send([se.Area.LED_STATUS, pedal, value])

    def leds_off(self):
        for pedal in range(0, 9 + 1):
            self.led(pedal, se.OFF)

    def flash(self, pedal):
        self.led(pedal, se.ON)
        self._tasks.add(Task.sequence(
            Task.wait(0.1),
            Task.run(lambda: self.led(pedal, se.OFF))
        ))

    def blink(self, pedal, interval):
        """Blink one LED until the returned task is killed."""
        values = itertools.cycle((se.ON, se.OFF))
        return self._tasks.add(Task.loop(Task.sequence(
            Task.wait(interval),
            Task.run(lambda: self.led(pedal, next(values)))
        )))

    def set_bank_display(self, left, right):
        """Show two characters; set_bank_display_temp returns to this."""
        self._bank_display = (se.segments(left), se.segments(right))
        self._write_bank_display(*self._bank_display)

    def set_bank_display_temp(self, left, right, timeout=1):
        """Show two raw segment bitmasks, then return to the last set_bank_display.

        A newer call replaces a pending return.
        """
        if self._restore_task is not None:
            self._restore_task.kill()
        self._write_bank_display(left, right)
        self._restore_task = self._tasks.add(Task.sequence(
            Task.wait(timeout),
            Task.run(lambda: self._write_bank_display(*self._bank_display))
        ))

    def _write_bank_display(self, left, right):
        self.send([se.Area.BANK_DISPLAY_STATUS, se.BANK_DISPLAY_LEFT, left])
        self.send([se.Area.BANK_DISPLAY_STATUS, se.BANK_DISPLAY_RIGHT, right])
