<script lang="ts">
  import { fade } from "svelte/transition";
  import type { Favorite } from "../lib/state";
  import CloseButton from "../lib/CloseButton.svelte";
  import Dial from "../lib/Dial.svelte";
  import { paramDrag } from "../lib/paramDrag.svelte";
  import { connection } from "../lib/client";
  import { appState } from "../lib/state";
  import { holdInteractive, wake } from "../lib/touch";

  // The favorite the expression pedal controls on page 2, over the whole screen.
  // Shown whatever page this app shows (follow or not): picking it is a pedal action.
  // Dragging up/down sets it, like the tiles on the loops page.
  // ← (`onback`) only hides it here; ✕ also drops the favorite on the FC-200.
  let { favorite, onback }: { favorite: Favorite; onback: () => void } = $props();

  // Re-entering the page drops the favorite, like a bank pedal at the last page
  // (page.set)
  function exit() {
    connection.send("page.set", { page: $appState.page ?? 2 });
    onback();
  }

  const drag = paramDrag(() => favorite);

  // Touch mode while it is up (App locks it again when the FC-200 drops it)
  $effect(() => {
    wake();
    return holdInteractive();
  });
</script>

<div
  class="favorite"
  role="slider"
  aria-label={favorite.name}
  aria-valuemin={0}
  aria-valuemax={1}
  aria-valuenow={drag.value}
  aria-valuetext={drag.display}
  tabindex="-1"
  style:--value={drag.value}
  onpointerdown={drag.onpointerdown}
  onpointermove={drag.onpointermove}
  onpointerup={drag.onpointerup}
  onpointercancel={drag.onpointercancel}
  transition:fade={{ duration: 120 }}
>
  <!-- buttons, not drags: they keep the pointer from the slider -->
  <button class="back" aria-label="back" onpointerdown={(e) => e.stopPropagation()} onclick={onback}>←</button>
  <span class="exit"><CloseButton label="exit on the FC-200" onclick={exit} /></span>

  <!-- the value fills the screen from the bottom -->
  <div class="fill"></div>
  <div class="text">
    <div class="loop"><span class="pedal">{favorite.pedal}</span> {favorite.loop_name}</div>
    <div class="name">{favorite.name}</div>
    <div class="dial"><Dial value={drag.value} dragging={drag.dragging} /></div>
    <div class="display">{drag.display}</div>
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
  .back,
  .exit {
    position: absolute;
    z-index: 1;
    top: calc(var(--space-3) + var(--safe-top));
  }
  .back {
    width: var(--touch);
    min-width: 0;
    padding: 0;
    font-size: var(--text-name);
    color: var(--text-muted);
    background: var(--panel);
    left: max(var(--space-4), var(--safe-left));
  }
  .exit {
    right: max(var(--space-4), var(--safe-right));
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
