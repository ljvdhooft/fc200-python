<script lang="ts">
  import { fade } from "svelte/transition";
  import { connection } from "../lib/client";
  import { abletonConnected, type Favorite } from "../lib/state";
  import { interactive, keepInteractive } from "../lib/touch";
  import { throttle } from "../lib/throttle";

  // The favorite the expression pedal controls on page 2, over the whole screen.
  // Shown whatever page this app shows (follow or not): picking it is a pedal action.
  // Dragging up/down sets it, like the tiles on the loops page.
  let { favorite }: { favorite: Favorite } = $props();

  const RANGE = 320; // px of travel for the full range
  const CONFIRM = 2000;
  let drag = $state<{ y: number; start: number; value: number } | null>(null);
  let held = $state<number | undefined>(); // the last dragged value, until Ableton confirms it
  let heldTimer: ReturnType<typeof setTimeout> | undefined;
  const send = throttle((value: number) =>
    connection.send("loop.param.set", { loop: favorite.loop, parameter: favorite.parameter, value }),
  );

  $effect(() => {
    if (held !== undefined && Math.abs(favorite.value - held) < 0.005) held = undefined;
  });
  let value = $derived(drag?.value ?? held ?? favorite.value);
  // From bottom-left (135°) clockwise round to bottom-right (45°), radius 38
  const ARC = "M 23.13 76.87 A 38 38 0 1 1 76.87 76.87";
  let enabled = $derived($abletonConnected && $interactive);

  function onpointerdown(e: PointerEvent) {
    if (!enabled) return;
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
    drag = { y: e.clientY, start: value, value };
  }
  function onpointermove(e: PointerEvent) {
    if (!drag) return;
    drag.value = Math.min(1, Math.max(0, drag.start + (drag.y - e.clientY) / RANGE));
    send(drag.value);
    keepInteractive();
  }
  function onpointerup() {
    if (!drag) return;
    send.flush();
    held = drag.value;
    clearTimeout(heldTimer);
    heldTimer = setTimeout(() => (held = undefined), CONFIRM);
    drag = null;
  }
</script>

<div
  class="favorite"
  role="slider"
  aria-label={favorite.name}
  aria-valuemin={0}
  aria-valuemax={1}
  aria-valuenow={value}
  aria-valuetext={favorite.display}
  tabindex="-1"
  style:--value={value}
  {onpointerdown}
  {onpointermove}
  {onpointerup}
  onpointercancel={() => (drag = null)}
  transition:fade={{ duration: 120 }}
>
  <!-- the value fills the screen from the bottom -->
  <div class="fill"></div>
  <div class="text">
    <div class="loop"><span class="pedal">{favorite.pedal}</span> {favorite.loop_name}</div>
    <div class="name">{favorite.name}</div>
    <!-- Ableton-style dial: a 270° arc open at the bottom, the needle from the centre -->
    <svg class="dial" viewBox="0 0 100 100" aria-hidden="true">
      <path class="track" d={ARC} />
      <path class="arc" d={ARC} pathLength="1" stroke-dasharray="{value} 1" />
      <line class="needle" x1="50" y1="50" x2="88" y2="50" style:rotate="{135 + 270 * value}deg" />
    </svg>
    <div class="display">{favorite.display}</div>
  </div>
</div>

<style>
  .favorite {
    position: fixed;
    inset: 0;
    z-index: 20;
    background: var(--bg);
    touch-action: none;
    overflow: hidden;
  }
  .fill {
    position: absolute;
    inset: 0;
    transform-origin: bottom;
    transform: scaleY(var(--value));
    background: color-mix(in srgb, var(--accent-on) 22%, var(--bg));
    border-top: 2px solid var(--accent-on);
    /* just smooths the pedal's steps; longer and it trails behind */
    transition: transform 80ms linear;
  }
  .text {
    position: relative;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    padding: var(--safe-top) var(--safe-right) var(--safe-bottom) var(--safe-left);
    text-align: center;
    pointer-events: none;
  }
  .loop {
    font-size: var(--text-body);
    color: var(--text-muted);
  }
  .pedal {
    color: var(--accent-on);
    font-variant-numeric: tabular-nums;
  }
  .name {
    font-size: 44px;
    line-height: 1.1;
    color: var(--text);
  }
  .dial {
    width: 160px;
    height: 160px;
    margin-top: var(--space-2);
    /* the value tucks up into the dial's open bottom, like Ableton's */
    margin-bottom: -36px;
    fill: none;
    stroke-width: 7;
  }
  .track {
    stroke: var(--panel-2);
  }
  .arc {
    stroke: var(--accent-on);
  }
  .needle {
    stroke: var(--text);
    stroke-width: 4;
    stroke-linecap: round;
    transform-origin: 50px 50px;
  }
  .arc,
  .needle {
    transition: all 80ms linear;
  }
  .display {
    font-size: 72px;
    line-height: 1;
    color: var(--text);
    font-variant-numeric: tabular-nums;
  }
</style>
