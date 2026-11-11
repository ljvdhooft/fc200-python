<script lang="ts">
  import type { Tuner } from "../lib/state";
  import { hue, lightness, offset, TOLERANCE } from "../lib/tuner";

  // A bar along the bottom while the volume is 0 (in a Drawer, see App.svelte). The needle is the edge of a fill
  // that grows from the middle; its colour goes from green (in tune) to red.
  let { tuner }: { tuner: Tuner } = $props();

  let share = $derived(offset(tuner.cents));
  let colour = $derived(`hsl(${hue(tuner.cents)} 70% ${lightness(tuner.cents)}%)`);
</script>

<!-- The base covers what scrolls under the bar, down to the screen edge -->
<div class="base">
<div class="tuner" style:--tuner-colour={colour}>
  <span class="note">{tuner.note}</span>
  <div class="track" role="meter" aria-label="tuning" aria-valuemin={-50} aria-valuemax={50} aria-valuenow={tuner.cents}>
    <span class="centre"></span>
    <span class="tolerance" style:left={`${50 + offset(-TOLERANCE) * 50}%`}></span>
    <span class="tolerance" style:left={`${50 + offset(TOLERANCE) * 50}%`}></span>
    <span
      class="fill"
      style:left={share < 0 ? `${50 + share * 50}%` : "50%"}
      style:width={`${Math.abs(share) * 50}%`}
    ></span>
    <span class="needle" style:left={`${50 + share * 50}%`}></span>
  </div>
</div>
</div>

<style>
  /* Fades the rows out above the bar, like the scene list's own edge fade
     (Scenes.svelte .list mask) when the controls take its place */
  .base {
    pointer-events: none; /* display only: touches reach the list under it */
    padding: var(--space-5) 0 var(--inset-bottom);
    background: linear-gradient(transparent, var(--bg) var(--space-5));
  }
  .tuner {
    display: flex;
    align-items: center;
    height: calc(var(--touch) * 1.5); /* the transport buttons' height */
    position: relative; /* anchors the note */
    /* one thick, lighter edge around the track: its outer edge lines up with the scene rows */
    padding: var(--space-1);
    background: var(--border);
    border-radius: var(--radius);
  }
  /* Over the bar's left end, so the track (and its centre) spans the full width */
  .note {
    position: absolute;
    left: var(--space-3);
    top: 50%;
    translate: 0 -50%;
    z-index: 1;
    pointer-events: none;
    min-width: 2ch;
    font-size: var(--text-scene);
    line-height: 1;
    font-variant-numeric: tabular-nums;
    color: var(--text);
  }
  .track {
    position: relative;
    flex: 1;
    align-self: stretch;
    background: var(--panel-2);
    border-radius: 2px;
    overflow: hidden;
  }
  .centre {
    position: absolute;
    left: 50%;
    top: 0;
    bottom: 0;
    width: 2px;
    translate: -50% 0;
    background: var(--text-muted);
  }
  /* Phones: follow the screen's rounded corners, like the scene and loops pages'
     bottom buttons. Portrait: both bottom corners; landscape: only the outer bottom corner, away from the Dynamic Island
     (like the stop button) */
  @media (orientation: portrait) and (max-width: 500px) {
    .tuner {
      border-bottom-left-radius: var(--corner-concentric);
      border-bottom-right-radius: var(--corner-concentric);
    }
    /* a little up and in, clear of the curve below it */
    .note {
      translate: var(--space-2) calc(-50% - 3px);
    }
    /* concentric with the bar: its radius minus the padding */
    .track {
      border-bottom-left-radius: calc(var(--corner-concentric) - var(--space-1));
      border-bottom-right-radius: calc(var(--corner-concentric) - var(--space-1));
    }
  }
  @media (orientation: landscape) and (max-height: 500px) {
    :global(:root:not([data-island="right"])) .tuner {
      border-bottom-right-radius: var(--corner-concentric);
    }
    :global(:root[data-island="right"]) .tuner {
      border-bottom-left-radius: var(--corner-concentric);
    }
    :global(:root:not([data-island="right"])) .track {
      border-bottom-right-radius: calc(var(--corner-concentric) - var(--space-1));
    }
    :global(:root[data-island="right"]) .note {
      translate: var(--space-2) calc(-50% - 3px);
    }
    :global(:root[data-island="right"]) .track {
      border-bottom-left-radius: calc(var(--corner-concentric) - var(--space-1));
    }
  }

  /* The in-tune range either side of the centre, on top of the fill and needle */
  .tolerance {
    z-index: 1;
    position: absolute;
    top: 25%;
    bottom: 25%;
    width: 1px;
    translate: -50% 0;
    background: color-mix(in srgb, var(--status-error) 65%, black);
  }
  .fill {
    position: absolute;
    top: 0;
    bottom: 0;
    background: var(--tuner-colour);
    opacity: 0.6;
  }
  .needle {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 3px;
    translate: -50% 0;
    border-radius: 2px;
    background: var(--tuner-colour);
    box-shadow: 0 0 6px var(--tuner-colour);
  }
  /* Follows the tuner's updates closely: short and linear, not the app's settle */
  .fill,
  .needle {
    transition:
      left 80ms linear,
      width 80ms linear,
      background-color 80ms linear;
  }
</style>
