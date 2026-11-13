<script lang="ts">
  import { fade } from "svelte/transition";
  import { abletonConnected, type Loop } from "../lib/state";
  import ViewButton from "../lib/ViewButton.svelte";
  import ChainMenu from "./ChainMenu.svelte";
  import MacroView from "./Macro.svelte";

  // Parameter control from the app: a loop's 8 macros as dials, and its chain.
  // Opened here, it stands alone: the FC-200 stays in whatever mode it is in.
  // `followed`: opened by the FC-200's parameter control; `selected`: the macro
  // its expression pedal controls (a position in `loop.macros`). Followed, it has
  // a ← (`onback`) that only hides it here.
  let {
    loop,
    selected = null,
    followed = false,
    onclose,
    onback,
  }: {
    loop: Loop;
    selected?: number | null;
    followed?: boolean;
    onclose: () => void;
    onback: () => void;
  } = $props();

  // The chain button opens the same menu as a long press on a loop tile, against
  // the screen's right edge: an anchor at that edge, which the menu clamps to
  let chainOpen = $state(false);
  let chainFrom = $state<string | undefined>(); // followed: the chain before the change

  // Followed: a chain change on the FC-200 shows the menu briefly. Not for a chain
  // picked here (its change arrives just after the menu closes).
  const FLASH = 1500;
  const OWN = 2000;
  let closedAt = 0;
  let flashTimer: ReturnType<typeof setTimeout> | undefined;
  let last: { loop: number; chain: string } | undefined; // what the view showed before
  $effect(() => {
    const { index, chain } = loop;
    const changed = last?.loop === index && last.chain !== chain; // not a switch to another loop
    const previous = last?.chain;
    last = { loop: index, chain };
    if (!changed || !followed || Date.now() - closedAt < OWN) return;
    if (!chainOpen) chainFrom = previous;
    chainOpen = true;
    clearTimeout(flashTimer);
    flashTimer = setTimeout(() => {
      chainOpen = false;
      chainFrom = undefined;
    }, FLASH);
  });
  $effect(() => () => clearTimeout(flashTimer));
  function closeChains() {
    clearTimeout(flashTimer);
    chainOpen = false;
    chainFrom = undefined;
    closedAt = Date.now();
  }
</script>

<div class="edit" transition:fade={{ duration: 120 }}>
  <!-- the same columns as the dials: the chain button starts at the third -->
  <header>
    <span class="title">
      {#if followed}<ViewButton glyph="←" label="back" onclick={onback} />{/if}
      <span class="pedal">{loop.pedal}</span>
      <span class="name">{loop.name}</span>
    </span>
    <span class="end">
      <button
        class="chain"
        aria-haspopup="dialog"
        disabled={!$abletonConnected}
        onclick={() => (chainOpen = true)}
      >
        <span class="label">chain</span>
        <span class="current">{loop.chain}</span>
      </button>
      <ViewButton glyph="✕" label="close" onclick={onclose} />
    </span>
  </header>

  <section class="macros">
    {#each loop.macros as macro, i (macro.parameter)}
      <MacroView loop={loop.index} {macro} selected={i === selected} />
    {/each}
  </section>

  {#if chainOpen}
    <ChainMenu {loop} from={chainFrom} anchor={new DOMRect(innerWidth, 0, 0, 0)} onclose={closeChains} />
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
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    column-gap: var(--space-2);
    align-items: center;
  }
  .title {
    grid-column: 1 / 3;
    display: flex;
    align-items: center;
    gap: var(--space-3);
    min-width: 0;
  }
  .end {
    grid-column: 3 / -1;
    display: flex;
    gap: var(--space-2);
    min-width: 0;
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
    flex: 1;
    min-width: 0;
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
  .macros {
    flex: 1;
    min-height: 0;
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    grid-template-rows: repeat(2, minmax(0, 1fr));
    gap: var(--space-2);
  }
  @media (orientation: portrait) {
    /* two columns: the name over the first, the chain over the second */
    .title {
      grid-column: 1;
    }
    .end {
      grid-column: 2;
    }
    header,
    .macros {
      grid-template-columns: repeat(2, minmax(0, 1fr));
      grid-template-rows: repeat(4, minmax(0, 1fr));
    }
  }
</style>
