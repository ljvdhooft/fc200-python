<script lang="ts">
  import { onMount } from "svelte";
  import { connection } from "../lib/client";
  import { appState } from "../lib/state";
  import { hex, number } from "../lib/scene";
  import Lock from "../lib/Lock.svelte";

  let fired = $derived($appState.scenes?.fired ?? null);
  let playing = $derived($appState.transport?.playing ?? false);

  // "playing" while the fired scene is what's playing. Once the transport stops it
  // is the "last" scene, also when the transport starts again without firing a
  // scene; firing one makes it "playing" again.
  let stopped = $state(!($appState.transport?.playing ?? false));
  $effect(() => {
    if (!playing) stopped = true;
  });
  // Every fire, also of the same scene again, comes as a `scene.fired` event
  // (resuming the transport doesn't count). Firing starts the transport, so don't
  // wait for `playing`: it may arrive in a later change.
  onMount(() => connection.on("scene.fired", () => (stopped = false)));
</script>

<div class="now">
  <span class="label">{fired && !stopped ? "playing" : "last"}</span>
  {#if fired}
    <span class="led" class:off={stopped}></span>
    <span class="strip" style:background={hex(fired.color)}></span>
    <span class="num">{number(fired)}</span>
    <span class="name">{fired.name}</span>
  {:else}
    <span class="name muted">nothing fired yet</span>
  {/if}
  <!-- Display mode: the first touch only wakes the page. Out here at the far end:
       the rail is the (expanded) Dynamic Island's and the page menu's -->
  <span class="lock"><Lock /></span>
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
    min-width: 6ch; /* "playing" and "last" take the same room */
    margin-right: var(--space-2);
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .muted {
    color: var(--text-muted);
  }
  /* the scene colour as a line, like in the list */
  .strip {
    align-self: stretch;
    width: 6px;
    flex: none;
    /* it belongs to the scene: tight to its number, apart from the light */
    margin-left: var(--space-2);
    margin-right: calc(-1 * var(--space-1));
  }
  .led {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--accent-on);
    box-shadow: 0 0 6px color-mix(in srgb, var(--accent-on) 60%, transparent);
    flex: none;
    transition:
      background var(--motion) var(--ease),
      box-shadow var(--motion) var(--ease);
  }
  .led.off {
    background: var(--text-muted);
    box-shadow: none;
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
