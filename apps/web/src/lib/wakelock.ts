let sentinel: WakeLockSentinel | null = null;

async function acquire(): Promise<void> {
  if (!("wakeLock" in navigator) || document.visibilityState !== "visible" || sentinel) return;
  try {
    sentinel = await navigator.wakeLock.request("screen");
    sentinel.addEventListener("release", () => (sentinel = null));
  } catch {
    sentinel = null; // denied (low battery, no user gesture yet): retried on the next event
  }
}

/** Keep the screen on; re-acquire after the tab was hidden or on first touch. */
export function keepAwake(): void {
  void acquire();
  document.addEventListener("visibilitychange", () => void acquire());
  document.addEventListener("pointerdown", () => void acquire());
}
