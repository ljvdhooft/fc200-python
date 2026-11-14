<script lang="ts">
  import type { Macro } from "../lib/state";
  import Dial from "../lib/Dial.svelte";
  import { paramDrag } from "../lib/paramDrag.svelte";

  // One of a loop's macros in the edit view: drag the cell up/down to set it.
  // `selected`: the FC-200's expression pedal controls it.
  let { loop, macro, selected = false }: { loop: number; macro: Macro; selected?: boolean } = $props();

  const drag = paramDrag(() => ({ loop, ...macro }));
</script>

<div
  class="macro"
  class:selected
  class:held={drag.dragging /* the global press look, for the whole drag */}
  role="slider"
  aria-label={macro.name}
  aria-valuemin={0}
  aria-valuemax={1}
  aria-valuenow={drag.value}
  aria-valuetext={drag.display}
  tabindex="-1"
  onpointerdown={drag.onpointerdown}
  onpointermove={drag.onpointermove}
  onpointerup={drag.onpointerup}
  onpointercancel={drag.onpointercancel}
>
  <div class="name">{macro.name}</div>
  <div class="dial"><Dial value={drag.value} dragging={drag.dragging} /></div>
  <div class="display">{drag.display}</div>
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
    transition:
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      filter var(--motion) var(--ease);
  }
  .selected {
    background: color-mix(in srgb, var(--accent-select) 12%, var(--panel));
    border-color: var(--accent-select);
  }
  .name {
    max-width: 100%;
    font-size: var(--text-name);
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
    /* the arc ends well above the box's bottom edge: pull the value up to it */
    margin-bottom: -14px;
  }
  .display {
    font-size: var(--text-name);
    line-height: 1;
    color: var(--text);
    font-variant-numeric: tabular-nums;
    white-space: nowrap;
  }
</style>
