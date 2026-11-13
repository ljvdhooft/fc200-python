<script lang="ts">
  import { fade } from "svelte/transition";
  import { connection } from "../lib/client";
  import { expect } from "../lib/optimistic";
  import { FADE } from "../lib/motion";
  import { abletonConnected } from "../lib/state";
  import { holdInteractive } from "../lib/touch";
  import ViewButton from "../lib/ViewButton.svelte";

  // Type a tempo (tapping the BPM). Starts empty, with the current tempo as the
  // placeholder; the check sends it (tempo.set) and shows it at once.
  let { tempo, onclose }: { tempo: number | undefined; onclose: () => void } = $props();

  $effect(() => holdInteractive());

  const MIN = 20; // Live's range (tempo.set clamps to it as well)
  const MAX = 999;
  let typed = $state("");
  let value = $derived(Number(typed));
  let valid = $derived(typed !== "" && typed !== "." && value >= MIN && value <= MAX);

  function key(k: string) {
    if (k === "⌫") {
      typed = typed.slice(0, -1);
      return;
    }
    const next = typed + k;
    // up to three digits, then at most two decimals
    if (/^\d{0,3}(\.\d{0,2})?$/.test(next)) typed = next;
  }

  function set() {
    if (!valid) return;
    expect("tempo", value);
    connection.send("tempo.set", { tempo: value });
    onclose();
  }

  const KEYS = ["7", "8", "9", "4", "5", "6", "1", "2", "3", ".", "0", "⌫"];
</script>

<!-- tapping the blurred page around the pad closes it -->
<div
  class="backdrop"
  data-always
  transition:fade={{ duration: FADE }}
  onclick={(e) => e.target === e.currentTarget && onclose()}
  role="presentation"
>
  <div class="pad" role="dialog" aria-label="tempo">
    <header>
      <span class="label">tempo</span>
      <span class="actions">
        <button class="set" data-always disabled={!valid || !$abletonConnected} onclick={set} aria-label="set">
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
        </button>
        <ViewButton glyph="✕" label="close" always onclick={onclose} />
      </span>
    </header>
    <div class="display" class:placeholder={typed === ""}>
      {typed === "" ? (tempo === undefined ? "–" : Math.round(tempo * 100) / 100) : typed}<span class="unit">bpm</span>
    </div>
    <div class="keys">
      {#each KEYS as k (k)}
        <button data-always onclick={() => key(k)} aria-label={k === "⌫" ? "delete" : k}>{k}</button>
      {/each}
    </div>
  </div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: grid;
    place-items: center;
    background: color-mix(in srgb, var(--bg) 30%, transparent);
    backdrop-filter: blur(6px);
    -webkit-backdrop-filter: blur(6px);
  }
  .pad {
    width: min(280px, calc(100% - 2 * var(--space-4)));
    max-height: calc(100% - var(--safe-top) - var(--safe-bottom) - 2 * var(--space-3));
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
    padding: var(--space-2);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: calc(var(--radius) * 2);
    box-shadow: 0 8px 32px rgb(0 0 0 / 0.6);
  }
  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-left: var(--space-2);
  }
  .label {
    font-size: var(--text-label);
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.08em;
  }
  .display {
    padding: var(--space-2) var(--space-3);
    text-align: right;
    font-size: var(--text-scene);
    color: var(--text);
    font-variant-numeric: tabular-nums;
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: var(--radius);
  }
  .display.placeholder {
    color: var(--text-muted);
  }
  .unit {
    margin-left: var(--space-2);
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .keys {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: var(--space-1);
  }
  .keys button {
    min-height: var(--touch);
    font-size: var(--text-name);
  }
  .actions {
    display: flex;
    gap: var(--space-1);
  }
  .set {
    display: grid;
    place-items: center;
    width: var(--touch);
    padding: 0;
    color: var(--accent-on);
    border-color: var(--accent-on);
    background: color-mix(in srgb, var(--accent-on) 12%, var(--panel-2));
  }
  .set svg {
    width: 22px;
    height: 22px;
    fill: none;
    stroke: currentColor;
    stroke-width: 2.5;
    stroke-linecap: round;
    stroke-linejoin: round;
  }
  .set:disabled {
    opacity: 0.4;
  }

  /* Landscape phones: the screen is too short for it all at full size. The pad
     takes the full height it may have and the keys share what's left */
  @media (orientation: landscape) and (max-height: 500px) {
    .pad {
      height: calc(100% - var(--safe-top) - var(--safe-bottom) - 2 * var(--space-3));
    }
    header,
    .display {
      flex: none;
    }
    .display {
      padding-block: var(--space-1);
      font-size: var(--text-name);
    }
    .keys {
      flex: 1;
      min-height: 0;
      grid-auto-rows: minmax(0, 1fr);
    }
    .keys button {
      min-height: 0;
    }
  }
</style>
