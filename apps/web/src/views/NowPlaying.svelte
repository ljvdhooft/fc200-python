<script lang="ts">
  import { appState } from "../lib/state";
  import { hex, number } from "../lib/scene";
  import { interactive } from "../lib/touch";
  import { fade } from "svelte/transition";
  import { FADE } from "../lib/motion";

  let fired = $derived($appState.scenes?.fired ?? null);
</script>

<div class="now">
  <span class="label">now playing</span>
  {#if fired}
    <span class="led"></span>
    <span class="swatch" style:background={hex(fired.color)}></span>
    <span class="num">{number(fired)}</span>
    <span class="name">{fired.name}</span>
  {:else}
    <span class="name muted">nothing fired yet</span>
  {/if}
  <!-- Display mode: the first touch only wakes the page. Out here at the far end:
       the rail is the (expanded) Dynamic Island's and the page menu's -->
  {#if !$interactive}
    <svg class="lock" viewBox="0 0 24 24" aria-label="locked: touch to wake" transition:fade={{ duration: FADE }}>
      <!-- Lucide "lock" (ISC) -->
      <rect x="3" y="11" width="18" height="11" rx="2" />
      <path class="shackle" d="M7 11V7a5 5 0 0 1 10 0v4" />
    </svg>
  {/if}
</div>

<style>
  .now {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    min-height: var(--touch);
    padding: 0 var(--space-3);
    background: var(--panel);
    border: 1px solid var(--border);
    border-left: 3px solid var(--accent-on);
    border-radius: var(--radius);
  }
  .label {
    margin-right: var(--space-2);
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .muted {
    color: var(--text-muted);
  }
  .swatch {
    width: 10px;
    height: 10px;
    border-radius: 2px;
    flex: none;
  }
  .led {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent-on);
    box-shadow: 0 0 6px color-mix(in srgb, var(--accent-on) 60%, transparent);
    flex: none;
  }
  .num {
    color: var(--text-muted);
    font-variant-numeric: tabular-nums;
    min-width: 2.5ch;
    text-align: right;
  }
  .name {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .lock {
    margin-left: auto;
    flex: none;
    width: 20px;
    height: 20px;
    fill: none;
    stroke: var(--text-muted);
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
    opacity: 0.6;
  }
  /* portrait: in the middle of the top bar instead */
  @media (orientation: portrait) {
    .lock {
      display: none;
    }
  }
  /* Landscape phones: the outer top corner (away from the island) meets the screen corner */
  @media (orientation: landscape) and (max-height: 500px) {
    :global(:root:not([data-island="right"])) .now {
      border-top-right-radius: var(--corner-concentric);
      padding-right: var(--space-5); /* clear of the curve */
    }
    :global(:root[data-island="right"]) .now {
      border-top-left-radius: var(--corner-concentric);
    }
  }
</style>
