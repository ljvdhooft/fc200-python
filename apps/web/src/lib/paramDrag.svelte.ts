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
 * Its text comes from the macro's display table (`loop.param.displays`) until then.
 * Call during component init: it sets up effects.
 */
export function paramDrag(
  target: () => { loop: number; parameter: number; value: number; display: string },
) {
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

  // Live's text for each of the macro's 128 steps, asked again when the macro changes
  let displays = $state<string[] | null>(null);
  // Only these two: the value changing must not ask again
  const loop = $derived(target().loop);
  const parameter = $derived(target().parameter);
  $effect(() => {
    let current = true;
    displays = null;
    connection
      .request<{ displays: string[] }>("loop.param.displays", { loop, parameter })
      .then((r) => current && (displays = r.displays))
      .catch(() => {}); // no table: the text just waits for Ableton
    return () => (current = false);
  });

  return {
    get value() {
      return value();
    },
    /** Live's display text, ahead of Ableton while the value is ours */
    get display() {
      const ours = drag?.value ?? held;
      if (ours === undefined || !displays) return target().display;
      return displays[Math.round(ours * (displays.length - 1))] ?? target().display;
    },
    get dragging() {
      return drag !== null;
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
