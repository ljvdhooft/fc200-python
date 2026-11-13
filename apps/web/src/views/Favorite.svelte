<script lang="ts">
  import { fade } from "svelte/transition";
  import type { Favorite } from "../lib/state";
  import Dial from "../lib/Dial.svelte";
  import { paramDrag } from "../lib/paramDrag.svelte";

  // The favorite the expression pedal controls on page 2, over the whole screen.
  // Shown whatever page this app shows (follow or not): picking it is a pedal action.
  // Dragging up/down sets it, like the tiles on the loops page.
  let { favorite }: { favorite: Favorite } = $props();

  const drag = paramDrag(() => favorite);
</script>

<div
  class="favorite"
  role="slider"
  aria-label={favorite.name}
  aria-valuemin={0}
  aria-valuemax={1}
  aria-valuenow={drag.value}
  aria-valuetext={favorite.display}
  tabindex="-1"
  style:--value={drag.value}
  onpointerdown={drag.onpointerdown}
  onpointermove={drag.onpointermove}
  onpointerup={drag.onpointerup}
  onpointercancel={drag.onpointercancel}
  transition:fade={{ duration: 120 }}
>
  <!-- the value fills the screen from the bottom -->
  <div class="fill"></div>
  <div class="text">
    <div class="loop"><span class="pedal">{favorite.pedal}</span> {favorite.loop_name}</div>
    <div class="name">{favorite.name}</div>
    <div class="dial"><Dial value={drag.value} dragging={drag.dragging} /></div>
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
  }
  .display {
    font-size: 72px;
    line-height: 1;
    color: var(--text);
    font-variant-numeric: tabular-nums;
  }
</style>
