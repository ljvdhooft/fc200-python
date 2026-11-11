<script lang="ts">
  import { fade } from "svelte/transition";
  import { connection } from "../lib/client";
  import type { Loop } from "../lib/state";
  import { FADE } from "../lib/motion";
  import { holdInteractive } from "../lib/touch";

  // Pick the loop's chain (long press on a loop tile): a narrow, full-height list
  // over the blurred page, centred on the held tile as far as the screen (and the
  // Dynamic Island's safe area) allows. Touch mode stays on while it is open.
  let { loop, anchor, onclose }: { loop: Loop; anchor: DOMRect | null; onclose: () => void } = $props();

  $effect(() => holdInteractive());

  const WIDTH = 280;
  let vw = $state(innerWidth);
  // Centred on the tile; the CSS clamps it inside the safe area
  let centre = $derived(anchor ? anchor.left + anchor.width / 2 : vw / 2);

  // Press feedback without :active, which lights up rows a scroll starts on: a row
  // shows pressed after a short delay, and a scroll (iOS cancels the pointer) undoes it
  const PRESS_DELAY = 80;
  let pressed = $state<string | null>(null);
  let pressTimer: ReturnType<typeof setTimeout> | undefined;
  function press(chain: string) {
    clearTimeout(pressTimer);
    pressTimer = setTimeout(() => (pressed = chain), PRESS_DELAY);
  }
  function release() {
    clearTimeout(pressTimer);
    pressed = null;
  }

  // The chosen row lights up as current, then the menu closes: the tap is seen
  let chosen = $state<string | null>(null);
  function select(chain: string) {
    if (chosen !== null) return;
    chosen = chain;
    if (chain !== loop.chain) connection.send("loop.chain.select", { loop: loop.index, chain });
    setTimeout(onclose, 80);
  }
</script>

<svelte:window bind:innerWidth={vw} />

<!-- tapping the blurred page around the menu closes it -->
<div class="backdrop" data-always transition:fade={{ duration: FADE }} onclick={(e) => e.target === e.currentTarget && onclose()} role="presentation">
<div
  class="menu"
  role="dialog"
  aria-label="{loop.name} chains"
  style:--want="{centre - WIDTH / 2}px"
  style:--width="{WIDTH}px"
>
  <header>
    <span class="pedal">{loop.pedal}</span>
    <span class="name">{loop.name}</span>
    <button class="close" data-always onclick={onclose} aria-label="close">✕</button>
  </header>
  <div class="chains" onscroll={release}>
    {#each loop.chains as chain (chain)}
      <button
        class="chain"
        class:current={chain === (chosen ?? loop.chain)}
        class:pressed={pressed === chain}
        data-always
        onpointerdown={() => press(chain)}
        onpointerup={release}
        onpointercancel={release}
        onpointerleave={release}
        onclick={() => select(chain)}
      >
        {chain}
      </button>
    {/each}
  </div>
</div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    background: color-mix(in srgb, var(--bg) 30%, transparent);
    backdrop-filter: blur(6px);
    -webkit-backdrop-filter: blur(6px);
  }
  .menu {
    --margin: var(--space-3);
    position: absolute;
    top: calc(var(--safe-top) + var(--margin));
    bottom: var(--inset-bottom);
    left: clamp(
      calc(var(--safe-left) + var(--margin)),
      var(--want),
      calc(100% - var(--safe-right) - var(--margin) - var(--width))
    );
    width: var(--width);
    max-width: calc(100% - var(--safe-left) - var(--safe-right) - 2 * var(--margin));
    padding: var(--space-2);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: calc(var(--radius) * 2);
    box-shadow: 0 8px 32px rgb(0 0 0 / 0.6);
    display: flex;
    flex-direction: column;
    gap: var(--space-3);
  }
  header {
    display: flex;
    align-items: baseline;
    gap: var(--space-3);
  }
  .pedal {
    color: var(--text-muted);
    font-size: var(--text-body);
  }
  .name {
    flex: 1;
    font-size: var(--text-name);
    color: var(--text);
  }
  .close {
    align-self: center;
    width: var(--touch);
    min-width: 0;
    padding: 0;
    color: var(--text-muted);
    background: var(--panel);
  }
  .chains {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    overscroll-behavior: contain;
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
  }
  .chain {
    flex: none;
    /* one line at the scene row's height; long names wrap and the row grows */
    min-height: var(--scene-row);
    padding: var(--space-2) var(--space-4);
    text-align: left;
    line-height: 1.25;
    white-space: normal;
    overflow-wrap: anywhere;
    font-size: var(--text-name);
    color: var(--text-muted);
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
  }
  .chain.pressed {
    background: color-mix(in srgb, var(--accent-select) 25%, var(--panel-2));
  }
  .chain.current {
    color: var(--text);
    background: color-mix(in srgb, var(--accent-select) 12%, var(--panel));
    border-color: var(--accent-select);
  }
</style>
