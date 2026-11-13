<script lang="ts">
  import { fade } from "svelte/transition";
  import { connection } from "../lib/client";
  import { abletonConnected, type Loop } from "../lib/state";
  import MacroView from "./Macro.svelte";

  // Parameter control from the app: a loop's 8 macros as dials, and its chain.
  // Stands alone: the FC-200 stays in whatever mode it is in.
  let { loop, onclose }: { loop: Loop; onclose: () => void } = $props();

  function selectChain(chain: string) {
    if (chain !== loop.chain) connection.send("loop.chain.select", { loop: loop.index, chain });
  }
</script>

<div class="edit" transition:fade={{ duration: 120 }}>
  <header>
    <span class="pedal">{loop.pedal}</span>
    <span class="name">{loop.name}</span>
    <select
      class="chain"
      aria-label="chain"
      value={loop.chain}
      disabled={!$abletonConnected}
      onchange={(e) => selectChain(e.currentTarget.value)}
    >
      {#each loop.chains as chain (chain)}
        <option value={chain}>{chain}</option>
      {/each}
    </select>
    <button class="close" onclick={onclose} aria-label="close">✕</button>
  </header>

  <section class="macros">
    {#each loop.macros as macro (macro.parameter)}
      <MacroView loop={loop.index} {macro} />
    {/each}
  </section>
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
    max-width: 50%;
    min-height: var(--touch);
    padding: 0 var(--space-3);
    background: var(--panel-2);
    color: var(--text);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    font: inherit;
    font-size: var(--text-body);
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
