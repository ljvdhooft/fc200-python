<script lang="ts">
  import { onMount, untrack } from "svelte";
  import { connection } from "../lib/client";
  import { view, localFires } from "../lib/optimistic";
  import { hex, number } from "../lib/scene";
  import Lock from "../lib/Lock.svelte";

  // Ahead of Ableton: a fire or play/stop from this client shows at once
  let fired = $derived($view.scenes?.fired ?? null);
  let playing = $derived($view.transport?.playing ?? false);
  // Fired, waiting for its launch (launch quantization)
  let waiting = $derived(fired != null && $view.scenes?.triggered === fired.index);

  // "playing" while the fired scene is what's playing. Once the transport stops it
  // is the "last" scene, also when the transport starts again without firing a
  // scene; firing one makes it "playing" again.
  let stopped = $state(untrack(() => !playing)); // from here on, the effects below
  $effect(() => {
    if (!playing) stopped = true;
  });
  // Every fire, also of the same scene again, comes as a `scene.fired` event
  // (resuming the transport doesn't count). Firing starts the transport, so don't
  // wait for `playing`: it may arrive in a later change.
  // A fire from this client counts at once.
  onMount(() => connection.on("scene.fired", () => (stopped = false)));
  onMount(() => {
    let first = true;
    return localFires.subscribe(() => {
      if (!first) stopped = false;
      first = false;
    });
  });
</script>

<div class="now" class:waiting>
  <span class="label">{waiting ? "fired" : fired && !stopped ? "playing" : "last"}</span>
  {#if fired}
    <span class="led" class:off={stopped}></span>
    <span class="strip" style:background={hex(fired.color)}></span>
    <span class="num">{number(fired)}</span>
    <span class="name">{fired.name}</span>
    {#if fired.preset}<span class="preset">⟡ {fired.preset}</span>{/if}
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
  /* the scene name wins: the preset gives way first, down to a few letters */
  .preset {
    flex: 0 100 auto;
    min-width: 6ch;
    margin-left: auto;
    text-align: right;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: var(--text-muted);
    font-size: var(--text-label);
  }
  .lock {
    margin-left: auto;
    flex: none;
  }
  /* the preset already pushes it to the end */
  .preset + .lock {
    margin-left: 0;
  }
  /* Fired, waiting for its launch: the accent line and the light pulse, like a
     triggered clip in Ableton. The label says "fired" too */
  .now.waiting {
    animation: wait-line 0.5s ease-in-out infinite alternate;
  }
  .now.waiting .led,
  .now.waiting::before {
    animation: wait-blink 0.5s ease-in-out infinite alternate;
  }
  @keyframes wait-line {
    to {
      border-left-color: var(--border);
    }
  }
  @keyframes wait-blink {
    to {
      opacity: 0.2;
    }
  }
  @media (prefers-reduced-motion: reduce) {
    .now.waiting,
    .now.waiting .led,
    .now.waiting::before {
      animation: none;
    }
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
    /* Inverted: the curve is on the orange line's end. The bar keeps the curve; the
       line moves in, past it (where the curve is nearly the full bar height) */
    :global(:root[data-island="right"]) .now {
      position: relative;
      overflow: hidden; /* the line follows the curve's edge where it crosses it */
      border-top-left-radius: var(--corner-concentric);
      border-left-width: 1px;
      border-left-color: var(--border);
      padding-left: calc(var(--space-5) + 3px + var(--space-3));
    }
    :global(:root[data-island="right"]) .now::before {
      content: "";
      position: absolute;
      left: var(--space-5);
      top: 0;
      bottom: 0;
      width: 3px;
      background: var(--accent-on);
    }
  }
</style>
