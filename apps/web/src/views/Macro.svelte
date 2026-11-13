<script lang="ts">
  import type { Macro } from "../lib/state";
  import Dial from "../lib/Dial.svelte";
  import { paramDrag } from "../lib/paramDrag.svelte";

  // One of a loop's macros in the edit view: drag the cell up/down to set it
  let { loop, macro }: { loop: number; macro: Macro } = $props();

  const drag = paramDrag(() => ({ loop, parameter: macro.parameter, value: macro.value }));
</script>

<div
  class="macro"
  role="slider"
  aria-label={macro.name}
  aria-valuemin={0}
  aria-valuemax={1}
  aria-valuenow={drag.value}
  aria-valuetext={macro.display}
  tabindex="-1"
  onpointerdown={drag.onpointerdown}
  onpointermove={drag.onpointermove}
  onpointerup={drag.onpointerup}
  onpointercancel={drag.onpointercancel}
>
  <div class="name">{macro.name}</div>
  <div class="dial"><Dial value={drag.value} /></div>
  <div class="display">{macro.display}</div>
</div>

<style>
  .macro {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 0;
    padding: var(--space-2);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    touch-action: none; /* the drag is ours, not a scroll */
  }
  .name {
    max-width: 100%;
    font-size: var(--text-body);
    color: var(--text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .dial {
    width: min(96px, 100%);
    aspect-ratio: 1;
    min-height: 0;
    flex-shrink: 1;
    margin-top: var(--space-1);
    /* the value tucks up into the dial's open bottom, like Ableton's */
    margin-bottom: -22%;
  }
  .display {
    font-size: var(--text-name);
    line-height: 1;
    color: var(--text);
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
  }
</style>
