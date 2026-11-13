<script lang="ts">
  import { fade } from "svelte/transition";
  import { abletonConnected, type Loop } from "../lib/state";
  import ChainMenu from "./ChainMenu.svelte";
  import MacroView from "./Macro.svelte";

  // Parameter control from the app: a loop's 8 macros as dials, and its chain.
  // Stands alone: the FC-200 stays in whatever mode it is in.
  let { loop, onclose }: { loop: Loop; onclose: () => void } = $props();

  // The chain button opens the same menu as a long press on a loop tile
  let chainButton = $state<HTMLButtonElement>();
  let chainAnchor = $state<DOMRect | null>(null);
</script>

<div class="edit" transition:fade={{ duration: 120 }}>
  <header>
    <span class="pedal">{loop.pedal}</span>
    <span class="name">{loop.name}</span>
    <button
      class="chain"
      bind:this={chainButton}
      aria-haspopup="dialog"
      disabled={!$abletonConnected}
      onclick={() => (chainAnchor = chainButton!.getBoundingClientRect())}
    >
      <span class="label">chain</span>
      <span class="current">{loop.chain}</span>
    </button>
    <button class="close" onclick={onclose} aria-label="close">✕</button>
  </header>

  <section class="macros">
    {#each loop.macros as macro (macro.parameter)}
      <MacroView loop={loop.index} {macro} />
    {/each}
  </section>

  {#if chainAnchor}
    <ChainMenu {loop} anchor={chainAnchor} onclose={() => (chainAnchor = null)} />
  {/if}
</div>

<style>
  .edit {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: flex;
    flex-direction: column;
    gap: var(--space-3);
    padding: calc(var(--space-2) + var(--safe-top)) max(var(--space-4), var(--safe-right))
      max(var(--space-4), var(--safe-bottom)) max(var(--space-4), var(--safe-left));
    background: var(--bg);
  }
  header {
    display: flex;
    align-items: center;
    gap: var(--space-3);
  }
  .pedal {
    color: var(--accent-on);
    font-variant-numeric: tabular-nums;
  }
  .name {
    font-size: var(--text-scene);
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .chain {
    margin-left: auto;
    min-width: 0;
    width: 240px;
    max-width: 50%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: var(--space-2);
    padding: 0 var(--space-4);
    background: var(--panel-2);
  }
  .chain .label {
    font-size: var(--text-label);
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.08em;
  }
  .chain .current {
    font-size: var(--text-body);
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .close {
    flex: none;
    width: var(--touch);
    min-width: 0;
    padding: 0;
    color: var(--text-muted);
  }
  .macros {
    flex: 1;
    min-height: 0;
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    grid-template-rows: repeat(2, minmax(0, 1fr));
    gap: var(--space-2);
  }
  @media (orientation: portrait) {
    .macros {
      grid-template-columns: repeat(2, minmax(0, 1fr));
      grid-template-rows: repeat(4, minmax(0, 1fr));
    }
  }
</style>
