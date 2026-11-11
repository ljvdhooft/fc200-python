import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { throttle } from "./throttle";

describe("throttle", () => {
  beforeEach(() => vi.useFakeTimers());
  afterEach(() => vi.useRealTimers());

  it("sends the first call at once and always sends the last value", () => {
    const fn = vi.fn();
    const t = throttle(fn, 33);
    t(1);
    t(2);
    t(3);
    expect(fn.mock.calls).toEqual([[1]]);
    vi.advanceTimersByTime(33);
    expect(fn.mock.calls).toEqual([[1], [3]]);
    vi.advanceTimersByTime(500);
    expect(fn).toHaveBeenCalledTimes(2);
  });

  it("limits the rate to about 30 Hz", () => {
    const fn = vi.fn();
    const t = throttle(fn, 33);
    for (let i = 0; i < 100; i++) {
      t(i);
      vi.advanceTimersByTime(10);
    }
    vi.advanceTimersByTime(100);
    expect(fn.mock.calls.length).toBeLessThanOrEqual(35);
    expect(fn.mock.calls.at(-1)).toEqual([99]);
  });

  it("flush sends the pending value, cancel drops it", () => {
    const fn = vi.fn();
    const t = throttle(fn, 33);
    t(1);
    t(2);
    t.flush();
    expect(fn.mock.calls).toEqual([[1], [2]]);
    t(3);
    t(4);
    t.cancel();
    vi.advanceTimersByTime(100);
    expect(fn).toHaveBeenCalledTimes(2);
  });
});
