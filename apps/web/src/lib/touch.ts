import { get, writable } from "svelte/store";

/**
 * Touch mode: the page is a passive display until it is touched. The first touch
 * only wakes the controls (the touch itself is swallowed, so it can't hit anything);
 * after IDLE ms without a touch the page goes back to display only.
 * Controls marked `data-always` act on the first touch and wake the page as well.
 */
export const interactive = writable(false);

export const IDLE = 3_000;

let timer: ReturnType<typeof setTimeout> | undefined;

/** Restart the idle timer, e.g. while a list is being scrolled. */
export function keepInteractive(): void {
  if (!get(interactive)) return;
  clearTimeout(timer);
  timer = setTimeout(() => interactive.set(false), IDLE);
}

export function trackTouch(): void {
  let swallowClick = false;
  let wakeAfterClick = false;

  window.addEventListener(
    "pointerdown",
    (e) => {
      const waking = !get(interactive);
      const always = !!(e.target as Element | null)?.closest?.("[data-always]");
      swallowClick = waking && !always;
      // iOS drops the click when the page changes under the finger, so a control that
      // acts on the first touch wakes the page only after its click went through
      wakeAfterClick = waking && always;
      if (swallowClick) {
        interactive.set(true);
        e.preventDefault();
        e.stopPropagation();
      }
      keepInteractive();
    },
    { capture: true },
  );
  window.addEventListener(
    "click",
    (e) => {
      if (wakeAfterClick) {
        wakeAfterClick = false;
        setTimeout(() => {
          interactive.set(true);
          keepInteractive();
        });
        return;
      }
      // The click that follows the waking touch must not reach the controls that just appeared
      if (!swallowClick) return;
      swallowClick = false;
      e.preventDefault();
      e.stopPropagation();
    },
    { capture: true },
  );
}
