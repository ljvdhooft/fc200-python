export interface Throttled<A extends unknown[]> {
  (...args: A): void;
  /** Send a pending trailing call now. */
  flush(): void;
  cancel(): void;
}

/**
 * Leading + trailing throttle: at most one call per `ms`, and the last
 * arguments are always delivered (after the interval if need be).
 */
export function throttle<A extends unknown[]>(fn: (...args: A) => void, ms = 33): Throttled<A> {
  let last = -Infinity;
  let pending: A | null = null;
  let timer: ReturnType<typeof setTimeout> | null = null;

  const fire = (args: A) => {
    last = Date.now();
    fn(...args);
  };

  const t = ((...args: A) => {
    const wait = last + ms - Date.now();
    if (wait <= 0 && timer === null) {
      fire(args);
      return;
    }
    pending = args;
    if (timer === null) {
      timer = setTimeout(() => {
        timer = null;
        const p = pending;
        pending = null;
        if (p) fire(p);
      }, Math.max(wait, 0));
    }
  }) as Throttled<A>;

  t.flush = () => {
    if (timer !== null) clearTimeout(timer);
    timer = null;
    const p = pending;
    pending = null;
    if (p) fire(p);
  };
  t.cancel = () => {
    if (timer !== null) clearTimeout(timer);
    timer = null;
    pending = null;
  };
  return t;
}
