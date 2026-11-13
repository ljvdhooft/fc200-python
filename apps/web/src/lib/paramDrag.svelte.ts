import { get } from "svelte/store";
import { connection } from "./client";
import { abletonConnected } from "./state";
import { interactive, keepInteractive } from "./touch";
import { throttle } from "./throttle";

const RANGE = 320; // px of travel up/down for the full range
const CONFIRM = 2000;

/**
 * Drag up/down to set a loop's macro (`loop.param.set`). The value follows the
 * finger, then holds the dragged value until Ableton reports it (or CONFIRM ms).
 * Call during component init: it sets up an effect.
 */
export function paramDrag(target: () => { loop: number; parameter: number; value: number }) {
  let drag = $state<{ y: number; start: number; value: number } | null>(null);
  let held = $state<number | undefined>();
  let heldTimer: ReturnType<typeof setTimeout> | undefined;
  const send = throttle((value: number) => {
    const { loop, parameter } = target();
    connection.send("loop.param.set", { loop, parameter, value });
  });

  $effect(() => {
    if (held !== undefined && Math.abs(target().value - held) < 0.005) held = undefined;
  });

  const value = () => drag?.value ?? held ?? target().value;

  return {
    get value() {
      return value();
    },
    onpointerdown(e: PointerEvent) {
      if (!get(abletonConnected) || !get(interactive)) return;
      (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
      drag = { y: e.clientY, start: value(), value: value() };
    },
    onpointermove(e: PointerEvent) {
      if (!drag) return;
      drag.value = Math.min(1, Math.max(0, drag.start + (drag.y - e.clientY) / RANGE));
      send(drag.value);
      keepInteractive();
    },
    onpointerup() {
      if (!drag) return;
      send.flush();
      held = drag.value;
      clearTimeout(heldTimer);
      heldTimer = setTimeout(() => (held = undefined), CONFIRM);
      drag = null;
    },
    onpointercancel() {
      drag = null;
    },
  };
}
