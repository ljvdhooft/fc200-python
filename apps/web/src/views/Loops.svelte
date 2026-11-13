<script lang="ts">
  import { connection } from "../lib/client";
  import { appState, abletonConnected, type Loop } from "../lib/state";
  import { holdInteractive, interactive, keepInteractive, sleep, wake } from "../lib/touch";
  import { throttle } from "../lib/throttle";
  import ChainMenu from "./ChainMenu.svelte";
  import Edit from "./Edit.svelte";
  import { follow } from "../lib/pages";

  let loops = $derived($appState.loops ?? []);

  // Optimistic: a tap or drag shows at once; Ableton confirms it later. Until then
  // the loop's LED is a ring (a tap) and the tile keeps the dragged value. Without
  // an answer in time, the tile falls back to what Ableton says.
  const CONFIRM = 2000;
  let pending = $state<Record<number, boolean>>({});
  let held = $state<Record<number, number>>({}); // the last dragged value per loop
  const timers = new Map<string, ReturnType<typeof setTimeout>>();
  function expire(key: string, drop: () => void) {
    clearTimeout(timers.get(key));
    timers.set(key, setTimeout(drop, CONFIRM));
  }
  // Confirmed once Ableton reports the value we sent
  $effect(() => {
    for (const loop of loops) {
      if (pending[loop.index] === loop.on) delete pending[loop.index];
      const v = held[loop.index];
      if (v !== undefined && Math.abs((loop.favorite?.value ?? v) - v) < 0.005) delete held[loop.index];
    }
  });

  const on = (loop: Loop): boolean => pending[loop.index] ?? loop.on;
  const unconfirmed = (loop: Loop): boolean => loop.index in pending;

  function toggle(loop: Loop) {
    const next = !on(loop);
    pending[loop.index] = next;
    expire(`on${loop.index}`, () => delete pending[loop.index]);
    connection.send("loop.set", { loop: loop.index, on: next });
  }

  // Edit mode: a tap opens the loop's macros instead of switching it. The page
  // doesn't lock while it is on.
  let editMode = $state(false);
  let editLoop = $state<number | null>(null);
  // Following: the FC-200's parameter control opens the same view, over one opened
  // here. Only closing goes back: closing the FC-200's loop leaves parameter control
  // there too (edit.close). The view stays hidden until the FC-200 confirms.
  let fcLoop = $derived($follow ? $appState.edit?.loop : undefined);
  let dismissed = $state<number | null>(null);
  $effect(() => {
    // runs when the FC-200 opens, switches or leaves a loop (it only reads fcLoop)
    if (fcLoop === undefined) dismissed = null;
    else editLoop = null;
  });
  let shownLoop = $derived(editLoop ?? (fcLoop !== dismissed ? fcLoop : undefined));
  let editing = $derived(loops.find((l) => l.index === shownLoop));
  // The macro the expression pedal controls, while the FC-200 edits this loop
  let selected = $derived(
    $appState.edit && $appState.edit.loop === shownLoop ? $appState.edit.selected : null,
  );
  // The FC-200's view opens in touch mode and doesn't lock, like edit mode
  let followed = $derived(editing !== undefined && editing.index === fcLoop);
  $effect(() => {
    if (!followed) return;
    wake();
    return holdInteractive();
  });
  // ...and display mode again as soon as the FC-200 leaves parameter control
  let wasFollowing = false;
  $effect(() => {
    const following = fcLoop !== undefined;
    if (wasFollowing && !$appState.edit) sleep(); // not when follow is switched off
    wasFollowing = following;
  });
  function closeEdit() {
    if (shownLoop !== undefined && shownLoop === fcLoop) connection.send("edit.close");
    editLoop = null;
    dismissed = fcLoop ?? null;
  }
  $effect(() => {
    if (editMode) return holdInteractive();
  });
  function tap(loop: Loop) {
    if (editMode) editLoop = loop.index;
    else toggle(loop);
  }

  // Dragging a tile (sideways or up/down) sets its favorite; a tap still toggles.
  // The bar follows the finger; the value text is Live's, once it arrives.
  const SLOP = 8; // px before a touch counts as a drag
  // px of travel for the full range: up/down a little finer than sideways
  const RANGE_X = 240;
  const RANGE_Y = 320;
  let drag = $state<{ loop: number; x: number; y: number; start: number; value: number; moved: boolean } | null>(null);
  const send = throttle((loop: number, parameter: number, value: number) =>
    connection.send("loop.param.set", { loop, parameter, value }),
  );

  function value(loop: Loop): number {
    if (drag?.loop === loop.index && drag.moved) return drag.value;
    if (loop.index in held) return held[loop.index];
    return loop.favorite?.value ?? 0;
  }

  // Holding a tile still opens its chain menu (moving cancels it: that's a drag)
  const HOLD = 850;
  let holdTimer: ReturnType<typeof setTimeout> | undefined;
  let holding = false; // the press became a hold: its release and click do nothing
  let menuLoop = $state<number | null>(null);
  let menuAnchor = $state<DOMRect | null>(null); // the held tile, to place the menu by
  let menu = $derived(loops.find((l) => l.index === menuLoop));

  function onpointerdown(e: PointerEvent, loop: Loop) {
    holding = false;
    clearTimeout(holdTimer);
    const tile = e.currentTarget as HTMLElement;
    holdTimer = setTimeout(() => {
      menuAnchor = tile.getBoundingClientRect();
      holding = true;
      drag = null;
      menuLoop = loop.index;
    }, HOLD);
    if (!loop.favorite) return;
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
    drag = { loop: loop.index, x: e.clientX, y: e.clientY, start: value(loop), value: value(loop), moved: false };
  }
  function onpointermove(e: PointerEvent, loop: Loop) {
    if (drag?.loop !== loop.index || !loop.favorite) return;
    const dx = e.clientX - drag.x;
    const dy = drag.y - e.clientY; // right or up raises it
    if (!drag.moved && Math.hypot(dx, dy) < SLOP) return;
    clearTimeout(holdTimer);
    drag.moved = true;
    drag.value = Math.min(1, Math.max(0, drag.start + dx / RANGE_X + dy / RANGE_Y));
    send(loop.index, loop.favorite.parameter, drag.value);
    keepInteractive();
  }
  function onpointerup(loop: Loop) {
    clearTimeout(holdTimer);
    if (drag?.loop !== loop.index) return;
    if (drag.moved) {
      send.flush();
      held[loop.index] = drag.value;
      expire(`value${loop.index}`, () => delete held[loop.index]);
    } else {
      tap(loop);
    }
    drag = null;
  }

  // Where a loop sits: like the FC-200's floor, pedals 6-10 above 1-5
  const column = (loop: Loop) => ((loop.pedal - 1) % 5) + 1;
  const row = (loop: Loop) => (loop.pedal > 5 ? 1 : 2);
</script>

<div class="page">
<section class="loops">
  {#each loops as loop (loop.index)}
    <button
      class="loop"
      class:on={on(loop)}
      class:unconfirmed={unconfirmed(loop)}
      class:passive={!$interactive}
      style:--column={column(loop)}
      style:--row={row(loop)}
      disabled={!$abletonConnected || !$interactive}
      class:dragging={drag?.loop === loop.index && drag.moved}
      onpointerdown={(e) => onpointerdown(e, loop)}
      onpointermove={(e) => onpointermove(e, loop)}
      onpointerup={() => onpointerup(loop)}
      onpointercancel={() => {
        clearTimeout(holdTimer);
        drag = null;
      }}
      onclick={() => holding || loop.favorite || tap(loop)}
      aria-pressed={on(loop)}
    >
      <span class="head">
        <span class="pedal">{loop.pedal}</span>
        <span class="name">{loop.name}</span>
        <span class="led"></span>
      </span>
      <span class="chain">{loop.chain}</span>

      {#if loop.favorite}
        <span class="favorite">
          <span class="param">{loop.favorite.name}</span>
          <span class="value">{loop.favorite.display}</span>
        </span>
        <!-- the favorite's value along the bottom edge -->
        <span class="bar" style:--value={value(loop)}></span>
      {/if}
    </button>
  {/each}
</section>

{#if menu}
  <ChainMenu loop={menu} anchor={menuAnchor} onclose={() => (menuLoop = null)} />
{/if}

<!-- Beside the grid in landscape, under it in portrait -->
{#if editing}
  <Edit loop={editing} {selected} {followed} onclose={closeEdit} onback={() => (dismissed = fcLoop ?? null)} />
{/if}

<aside class="side">
  <button
    class="edit"
    class:on={editMode}
    class:fc={$follow && $appState.page === 2}
    class:passive={!$interactive}
    disabled={!$interactive}
    aria-pressed={editMode}
    aria-label="edit"
    onclick={() => (editMode = !editMode)}
  >
    <!-- Lucide "sliders-vertical" (ISC) -->
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M4 21v-7M4 10V3M12 21v-9M12 8V3M20 21v-5M20 12V3M2 14h4M10 8h4M18 16h4" />
    </svg>
  </button>
  <!-- placeholder: presets come later -->
  <!-- no press look: it doesn't do anything yet -->
  <button class="presets" data-own-press class:passive={!$interactive} disabled={!$interactive}><span class="text">presets</span></button>
</aside>
</div>

<style>
  .page {
    display: flex;
    gap: var(--space-2);
    height: 100%;
  }
  .side {
    flex: none;
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
    width: calc(var(--touch) + var(--space-3));
  }
  /* square, above the presets */
  .edit {
    flex: none;
    aspect-ratio: 1;
    display: grid;
    place-items: center;
    padding: 0;
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text-muted);
    transition:
      opacity var(--motion) var(--ease),
      color var(--motion) var(--ease),
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      filter var(--motion) var(--ease);
  }
  .edit svg {
    width: 24px;
    height: 24px;
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
  }
  .presets {
    flex: 1;
    writing-mode: vertical-rl;
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: var(--text-body);
    letter-spacing: 0.08em;
    text-transform: uppercase;
    transition: opacity var(--motion) var(--ease);
  }
  /* following the FC-200 on page 2, where its pedals edit the loops */
  .edit.fc {
    color: var(--accent-select);
    border-color: var(--accent-select);
    background: color-mix(in srgb, var(--accent-select) 12%, var(--panel-2));
  }
  .edit.on {
    color: var(--accent-on);
    border-color: var(--accent-on);
    background: color-mix(in srgb, var(--accent-on) 12%, var(--panel-2));
  }
  /* clearly off in display mode */
  .edit.passive,
  .presets.passive {
    pointer-events: none;
    opacity: 0.3;
  }
  .loops {
    flex: 1;
    min-width: 0;
    display: grid;
    grid-template-columns: repeat(5, minmax(0, 1fr));
    grid-template-rows: repeat(2, minmax(0, 1fr));
    gap: var(--space-2);
    min-height: 0; /* flex sizes it, next to or above the presets */
  }
  .loop {
    grid-column: var(--column);
    grid-row: var(--row);
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    min-height: 0;
    padding: var(--space-3);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text-muted);
    text-align: left;
    overflow: hidden;
    touch-action: none; /* the drag is ours, not a scroll */
    transition:
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      color var(--motion) var(--ease),
      filter var(--motion) var(--ease);
  }
  .loop.on {
    color: var(--text);
    background: color-mix(in srgb, var(--accent-on) 8%, var(--panel));
    border-color: color-mix(in srgb, var(--accent-on) 70%, var(--border));
  }

  .head {
    display: flex;
    align-items: baseline;
    gap: var(--space-2);
  }
  .head .led {
    margin-left: auto;
    align-self: center;
    flex: none;
  }
  .pedal {
    font-size: var(--text-label);
    color: var(--text-muted);
    font-variant-numeric: tabular-nums;
  }
  .led {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--border);
    transition:
      background var(--motion) var(--ease),
      box-shadow var(--motion) var(--ease);
  }
  .on .led {
    background: var(--accent-on);
    box-shadow: 0 0 6px color-mix(in srgb, var(--accent-on) 60%, transparent);
  }
  /* sent, not yet confirmed by Ableton: a ring in the new state's colour */
  .unconfirmed .led,
  .on.unconfirmed .led {
    background: transparent;
    box-shadow: inset 0 0 0 1.5px var(--accent-on);
    transition: none;
  }
  .unconfirmed:not(.on) .led {
    box-shadow: inset 0 0 0 1.5px var(--text-muted);
  }

  /* the loop and its chain belong together; the favorite sits apart at the bottom */
  .name {
    min-width: 0;
    font-size: var(--text-name);
    line-height: 1.15;
  }
  .chain {
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .name,
  .chain,
  .param {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .favorite {
    margin-top: auto;
    display: flex;
    align-items: baseline;
    gap: var(--space-2);
    padding-bottom: var(--space-1);
  }
  .param {
    min-width: 0;
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .value {
    margin-left: auto;
    flex: none;
    font-size: var(--text-body);
    font-variant-numeric: tabular-nums;
  }
  .bar {
    position: absolute;
    left: 0;
    bottom: 0;
    height: 3px;
    width: calc(var(--value) * 100%);
    background: var(--text-muted);
    opacity: 0.5;
    transition:
      width var(--motion) var(--ease),
      background var(--motion) var(--ease);
  }
  /* no easing behind the finger */
  .dragging .bar {
    transition: none;
  }
  .dragging .bar,
  .on .bar {
    background: var(--accent-on);
    opacity: 0.8;
  }

  /* Disabled buttons swallow touches in some browsers; let the waking touch through */
  .loop.passive {
    pointer-events: none;
  }
  /* Display mode: the tiles go flat (no tint, muted text). Waking lights the tiles up, so they read as buttons. */
  .loop.passive,
  .loop.on.passive {
    color: var(--text-muted);
    background: var(--panel);
    border-color: var(--border);
  }
  /* ...but a loop that's on keeps a dimmed edge */
  .loop.on.passive {
    border-color: color-mix(in srgb, var(--accent-on) 30%, var(--border));
  }
  .passive .bar,
  .on.passive .bar {
    background: var(--text-muted);
    opacity: 0.5;
  }
  .loop:disabled:not(.passive) {
    opacity: 0.4;
  }

  /* Landscape phones: the outer bottom corner (away from the island) meets the
     screen corner */
  @media (orientation: landscape) and (max-height: 500px) {
    :global(:root:not([data-island="right"])) .presets {
      border-bottom-right-radius: var(--corner-concentric);
    }
    :global(:root[data-island="right"]) .page {
      flex-direction: row-reverse;
    }
    :global(:root[data-island="right"]) .presets {
      border-bottom-left-radius: var(--corner-concentric);
    }
  }

  /* Portrait phones: the bottom corners follow the screen's */
  @media (orientation: portrait) and (max-width: 500px) {
    /* side by side along the bottom: each takes one screen corner */
    .edit {
      border-radius: var(--radius) var(--radius) var(--radius) var(--corner-concentric);
    }
    .presets {
      border-radius: var(--radius) var(--radius) var(--corner-concentric) var(--radius);
    }
  }

  /* Portrait: two columns, in pedal order */
  @media (orientation: portrait) {
    .page {
      flex-direction: column;
    }
    .side {
      width: auto;
      height: calc(var(--touch) * 1.5);
      flex-direction: row;
    }
    .presets {
      writing-mode: horizontal-tb;
    }
    .loops {
      grid-template-columns: repeat(2, minmax(0, 1fr));
      grid-template-rows: none;
      grid-auto-rows: minmax(0, 1fr);
    }
    .loop {
      grid-column: auto;
      grid-row: auto;
    }
  }

  /* Inverted landscape: the rotated label reads the other way, mirroring it (only
     the text: the button stays as it is) */
  @media (orientation: landscape) {
    :global(:root[data-island="right"]) .presets .text {
      display: inline-block;
      rotate: 180deg;
    }
  }
</style>
