<script lang="ts">
  import { connection } from "../lib/client";
  import { appState, abletonConnected, type Scene } from "../lib/state";
  import { holdInteractive, interactive, keepInteractive, session, wake } from "../lib/touch";
  import { fade } from "svelte/transition";
  import { ease, FADE, GLIDE } from "../lib/motion";
  import { hex, number } from "../lib/scene";
  import { expect, localFires, view } from "../lib/optimistic";
  import Drawer from "../lib/Drawer.svelte";

  let scenes = $derived($appState.scenes);
  let serverSelected = $derived($appState.scenes?.selected ?? -1);
  let fired = $derived(scenes?.fired ?? null);
  let count = $derived(scenes?.count ?? 0);

  // Optimistic: a tap or prev/next shows at once, and stays until Ableton reports
  // that scene (in between, quick presses overtake Ableton's catching up). Without
  // an answer in time, the list falls back to what Ableton says.
  let pending = $state<number | null>(null);
  let pendingTimer: ReturnType<typeof setTimeout> | undefined;
  let selected = $derived(pending ?? serverSelected);
  $effect(() => {
    if (pending === serverSelected) pending = null; // confirmed
  });

  // The user scrolling the list themselves. It holds for this touch session and the
  // selection it started on (or that they tapped since); prev/next/fire, the pedal or
  // the end of touch mode make it stale, and the list follows the selection again.
  let browse = $state<{ session: number; at: number } | null>(null);
  let browsing = $derived(
    $interactive && browse !== null && browse.session === $session && (browse.at === selected || browse.at === serverSelected),
  );

  // The full list comes from scene.list (it isn't in the state). Fetched again when
  // the scene count changes and whenever touch mode starts (catches renames);
  // window and fired entries are always current, so they override it.
  let all = $state<Scene[]>([]);
  async function loadAll() {
    try {
      all = (await connection.request<{ scenes: Scene[] }>("scene.list")).scenes;
    } catch {
      // offline: keep what we have, the window still shows
    }
  }
  $effect(() => {
    if (count && $abletonConnected) loadAll();
  });
  $effect(() => {
    if ($interactive) loadAll();
  });
  let rows = $derived.by(() => {
    const byIndex = new Map(all.map((s) => [s.index, s]));
    for (const s of scenes?.window ?? []) byIndex.set(s.index, s);
    if (fired) byIndex.set(fired.index, fired);
    return [...byIndex.values()].sort((a, b) => a.index - b.index);
  });

  // Keep the selected scene centred, unless the user is browsing. Browsing ends
  // with touch mode, and the list glides back to the selection.
  let list: HTMLOListElement | undefined = $state();
  function target(): number | null {
    const row = list?.querySelector<HTMLElement>(`[data-index="${selected}"]`);
    if (!list || !row) return null;
    return row.offsetTop - (list.clientHeight - row.offsetHeight) / 2;
  }

  // Our own glide instead of scrollTo({behavior: "smooth"}): the same Apple-style
  // curve as the rest of the app, and it re-aims every frame, so the controls
  // closing at the same moment (which resizes the list) doesn't throw it off.
  let gliding = 0;
  function centre(animate: boolean) {
    cancelAnimationFrame(gliding);
    gliding = 0;
    const to = target();
    if (!list || to === null) return;
    const from = list.scrollTop;
    const distance = Math.abs(to - from);
    if (!animate || GLIDE === 0 || distance < 1) {
      list.scrollTop = to;
      return;
    }
    const duration = Math.min(GLIDE * 2, GLIDE + distance / 4); // longer trips take a little longer
    const start = performance.now();
    const frame = (now: number) => {
      const t = Math.min(1, (now - start) / duration);
      const aim = target() ?? to;
      list!.scrollTop = from + (aim - from) * ease(t);
      gliding = t < 1 ? requestAnimationFrame(frame) : 0;
    };
    gliding = requestAnimationFrame(frame);
  }
  function stopGlide() {
    cancelAnimationFrame(gliding);
    gliding = 0;
  }
  // Glide when the selection moves or browsing ends. Opening the page (or the list
  // filling in from scene.list) jumps straight there: nothing moved, so a glide
  // from the top would only distract.
  let centred: number | null = null;
  let wasBrowsing = false;
  $effect(() => {
    rows.length;
    const glide = centred !== null && (selected !== centred || wasBrowsing);
    wasBrowsing = browsing;
    if (browsing) return;
    centre(glide);
    if (target() !== null) centred = selected;
  });
  $effect(() => {
    // the controls opening/closing resizes the list: stay centred through it
    if (!list) return;
    const observer = new ResizeObserver(() => browsing || gliding || centre(false));
    observer.observe(list);
    return () => observer.disconnect();
  });
  function onscroll() {
    if (!$interactive) return;
    keepInteractive();
  }
  // Scrolling works straight away, also in display mode: it wakes touch mode
  // (taps on rows still need touch mode, the waking touch never selects)
  function ontouchmove() {
    stopGlide(); // a finger on the list wins
    wake();
    keepInteractive();
    browse = { session: $session, at: selected };
  }

  function optimistic(index: number) {
    pending = index;
    clearTimeout(pendingTimer);
    pendingTimer = setTimeout(() => (pending = null), 2000);
  }

  function select(index: number) {
    if (index < 0 || index >= count || index === selected) return;
    if (browsing) browse = { session: $session, at: index }; // a tap keeps the list where it is
    optimistic(index);
    connection.send("scene.select", { index });
  }

  // prev/next/fire: stepping through the set brings the list back to the selection
  function step(index: number) {
    if (index < 0 || index >= count) return;
    browse = null;
    optimistic(index);
    connection.send("scene.select", { index });
  }

  // Transport and preset store: the side column, like pedals 1/2 and 8 on page 0
  // Ahead of Ableton (lib/optimistic): a tap shows at once
  let playing = $derived($view.transport?.playing ?? false);
  let metronome = $derived($view.transport?.metronome ?? false);
  function play() {
    expect("transport.playing", true);
    connection.send("transport.play");
  }
  // Stop has no state of its own to show while already stopped: it flashes
  let stopFlash = $state(0);
  function stop() {
    expect("transport.playing", false);
    stopFlash++;
    connection.send("transport.stop");
  }
  function toggleMetronome() {
    const on = !metronome;
    expect("transport.metronome", on);
    connection.send("metronome.set", { on });
  }
  // Ahead of Ableton (lib/optimistic): cancelling drops it at once
  let pendingOverwrite = $derived(($view.presets?.pending_overwrite as string | null | undefined) ?? null);
  let canStore = $derived($appState.presets !== undefined);
  function store() {
    // a second store of the same scene confirms an overwrite: that one can only save,
    // so it shows "stored" at once (a save_failed event still turns it red)
    if (pendingOverwrite !== null) showStored("saved");
    else {
      stored = null; // a new store: drop an old outcome, so its own can show
      storing = true; // lit until the outcome shows (or CONFIRM passes)
    }
    clearTimeout(storingTimer);
    storingTimer = setTimeout(() => (storing = false), CONFIRM);
    connection.send("preset.store", { scene_index: selected });
  }
  const CONFIRM = 2000;
  let storing = $state(false);
  let storingTimer: ReturnType<typeof setTimeout> | undefined;
  $effect(() => {
    if (stored !== null || pendingOverwrite !== null) storing = false;
  });
  // A pending overwrite keeps touch mode on until it is confirmed or cancelled
  $effect(() => {
    if (pendingOverwrite !== null) return holdInteractive();
  });
  let cancelling = $state(false);
  function cancelOverwrite() {
    // lit for a moment, then everything closes (ahead of Ableton)
    cancelling = true;
    connection.send("preset.cancel");
    setTimeout(() => {
      expect("presets.pending_overwrite", null);
      cancelling = false;
    }, 120);
  }
  // The store's outcome, shown on the button for a moment
  const RESULT = 1500;
  let stored = $state<"saved" | "failed" | null>(null);
  let storedTimer: ReturnType<typeof setTimeout> | undefined;
  function showStored(result: "saved" | "failed") {
    stored = result;
    clearTimeout(storedTimer);
    storedTimer = setTimeout(() => (stored = null), RESULT);
  }
  $effect(() => {
    // only when not already showing it: a confirmed overwrite showed it on the tap
    const offSaved = connection.on("preset.saved", () => stored !== "saved" && showStored("saved"));
    const offFailed = connection.on("preset.save_failed", () => showStored("failed"));
    return () => {
      offSaved();
      offFailed();
      clearTimeout(storedTimer);
    };
  });

  // Fire and stop: the scene's clips recall their presets without anything playing
  // The selected scene becomes the fired one, ahead of Ableton
  function expectFired(playing: boolean) {
    const scene = rows.find((s) => s.index === selected);
    if (scene) expect("scenes.fired", scene);
    expect("transport.playing", playing);
  }

  function fireAndStop() {
    expectFired(false);
    browse = null;
    if (selected + 1 < count) optimistic(selected + 1);
    connection.send("scene.fire_and_stop");
  }

  function fire() {
    expectFired(true);
    localFires.update((n) => n + 1);
    // Fire launches the selected scene and selects the next one
    browse = null;
    if (selected + 1 < count) optimistic(selected + 1);
    connection.send("scene.fire");
  }
</script>

<section class="scenes" class:open={$interactive}>
<div class="body">
  <ol class="list" bind:this={list} {onscroll} {ontouchmove} onwheel={ontouchmove}>
    {#each rows as scene (scene.index)}
      <li data-index={scene.index}>
        <button
          class="row"
          class:selected={scene.index === selected}
          class:fired={scene.index === fired?.index}
          class:passive={!$interactive}
          disabled={!$abletonConnected || !$interactive}
          onclick={() => select(scene.index)}
        >
          <span class="strip" style:background={hex(scene.color)}></span>
          <span class="num">{number(scene)}</span>
          <span class="title">
            <span class="name">{scene.name}</span>
            {#if scene.preset}<span class="preset">⟡ {scene.preset}</span>{/if}
          </span>
          {#if scene.index === fired?.index}<span class="led" title="playing" transition:fade={{ duration: FADE }}></span>{/if}
        </button>
      </li>
    {/each}
  </ol>
  {#if pendingOverwrite !== null && stored === null}
    <!-- information only: the choice is on the side column, which stays clear -->
    <div class="overwrite-info" transition:fade={{ duration: FADE }}>
      <div class="card">
        <span class="label">overwrite preset?</span>
        <span class="name">{pendingOverwrite}</span>
      </div>
    </div>
  {/if}

  <!-- Always in the layout: its height animates with the slide, so the list
       re-centres in the same motion instead of jumping when the slide ends -->
  <Drawer open={$interactive} edge="bottom">
  <div class="controls">
    <button class="prev" disabled={!$abletonConnected || selected <= 0} onclick={() => step(selected - 1)}>◀ prev</button>
    <button class="fire" disabled={!$abletonConnected || selected < 0} onclick={fire}>
      fire
    </button>
    <button class="fire-stop" disabled={!$abletonConnected || selected < 0 || !canStore} onclick={fireAndStop}>fire &amp; stop</button>
    <button class="next" disabled={!$abletonConnected || selected >= count - 1} onclick={() => step(selected + 1)}>next ▶</button>
  </div>
  </Drawer>
</div>

<!-- Beside the list in landscape (away from the island), above it in portrait.
     Shown with touch mode, like the controls: it slides in the same way -->
<aside class="side" class:open={$interactive}>
<Drawer open={$interactive} edge="side">
<div class="side-buttons">
  <!-- top to bottom: store, metronome, play, stop (stop in the corner) -->
  {#if pendingOverwrite !== null && stored === null}
  <!-- An overwrite waits: store splits into confirm and cancel, blinking in turn -->
  <div class="overwrite-choice">
    <button class="confirm" disabled={!$abletonConnected} onclick={store} aria-label="confirm overwrite">
      <svg class="outline" viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
    </button>
    <button class="cancel" class:cancelling disabled={!$abletonConnected} onclick={cancelOverwrite} aria-label="cancel overwrite">
      <svg class="outline" viewBox="0 0 24 24" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" /></svg>
    </button>
  </div>
  {:else}
  <button
    class="store"
    class:saved={stored === "saved"}
    class:storing
    class:failed={stored === "failed"}
    disabled={!$abletonConnected || !canStore || selected < 0}
    onclick={store}
  >
    <span class="text">{#if stored === "saved"}stored ✓{:else if stored === "failed"}failed{:else}store{/if}</span>
  </button>
  {/if}
  <button
    class="metronome"
    class:on={metronome}
    disabled={!$abletonConnected}
    onclick={toggleMetronome}
    aria-pressed={metronome}
    aria-label="metronome"
  >
    <!-- Ableton's metronome: two dots side by side, the first open, the second filled -->
    <svg class="outline" viewBox="0 0 24 24" aria-hidden="true">
      <circle cx="7" cy="12" r="3.6" />
      <circle class="filled" cx="17" cy="12" r="3.6" />
    </svg>
  </button>
  <button class="play" aria-label="play" class:on={playing} disabled={!$abletonConnected} onclick={play}>
    <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 5v14l11-7z" /></svg>
  </button>
  <button class="stop" aria-label="stop" disabled={!$abletonConnected} onclick={stop}>
    <svg viewBox="0 0 24 24" aria-hidden="true"><rect x="6" y="6" width="12" height="12" rx="1" /></svg>
    <!-- restarts on every tap -->
    {#key stopFlash}{#if stopFlash}<span class="flash"></span>{/if}{/key}
  </button>
</div>
</Drawer>
</aside>
</section>

<style>
  .scenes {
    --side: calc(var(--touch) + var(--space-3)); /* the side column's width */
    position: relative; /* anchors the side column */
    display: flex;
    gap: var(--space-2);
    height: 100%;
  }
  :global(:root[data-island="right"]) .scenes {
    flex-direction: row-reverse;
  }
  .body {
    --drawer-gap: var(--space-3);
    flex: 1;
    min-width: 0;
    min-height: 0; /* portrait stacks it under the side row: don't grow past the screen */
    display: flex;
    flex-direction: column;
    gap: var(--space-3);
  }

  /* Landscape: the column floats over the list's outer edge and its buttons slide
     in; the rows (not the list) make room for it. Narrowing the list itself would
     change its width under the finger, and iOS cancels the scroll that the waking
     touch is starting. */
  .side {
    position: absolute;
    top: 0;
    bottom: 0;
    right: 0;
    width: var(--side);
    pointer-events: none; /* hidden: touches go through to the list under it */
  }
  .side-buttons {
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
  }
  :global(:root[data-island="right"]) .side {
    right: auto;
    left: 0;
  }
  .list > li {
    transition: padding var(--motion) var(--ease);
  }
  .scenes.open .list > li {
    padding-right: calc(var(--side) + var(--space-2));
  }
  :global(:root[data-island="right"]) .scenes.open .list > li {
    padding-right: 0;
    padding-left: calc(var(--side) + var(--space-2));
  }
  /* the controls only show with the column, so they always leave it room */
  .controls {
    margin-right: calc(var(--side) + var(--space-2));
  }
  :global(:root[data-island="right"]) .controls {
    margin-right: 0;
    margin-left: calc(var(--side) + var(--space-2));
  }
  .side.open {
    pointer-events: auto;
  }
  .side button {
    width: calc(var(--touch) + var(--space-3));
  }
  .side button {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    writing-mode: vertical-rl;
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: var(--text-body);
    letter-spacing: 0.08em;
    text-transform: uppercase;
    transition:
      opacity var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      background var(--motion) var(--ease),
      filter var(--motion) var(--ease);
  }
  .side svg {
    width: 18px;
    height: 18px;
    flex: none;
    fill: currentColor;
  }
  /* the icon buttons take their size, the labelled ones share the rest */
  .side .play,
  .side .stop {
    flex: none;
    height: calc(var(--touch) + var(--space-3));
  }
  /* level with the controls along the bottom */
  .side .stop {
    height: calc(var(--touch) * 1.5);
  }
  .side .stop {
    position: relative;
    overflow: hidden;
  }
  /* a tap on stop lights it briefly, then fades */
  .flash {
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: color-mix(in srgb, var(--text) 30%, transparent);
    animation: flash 500ms var(--ease) both;
    pointer-events: none;
  }
  @keyframes flash {
    to {
      opacity: 0;
    }
  }
  .play.on {
    color: var(--status-live);
    border-color: var(--status-live);
    background: color-mix(in srgb, var(--status-live) 10%, var(--panel-2));
  }
  .side .metronome {
    flex: none;
    height: calc(var(--touch) + var(--space-3));
  }
  .side svg.outline {
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linejoin: round;
    stroke-linecap: round;
  }
  .side svg .filled {
    fill: currentColor;
  }
  .side .metronome svg {
    width: 34px;
    height: 34px;
    stroke-width: 1.6;
  }
  /* like Ableton's own metronome button: lit orange, dark dots */
  .metronome.on {
    color: var(--bg);
    border-color: var(--accent-on);
    background: var(--accent-on);
  }
  /* Overwrite: confirm and cancel take the store button's place; confirm blinks */
  .overwrite-choice {
    flex: 1;
    min-height: 0;
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
  }
  .overwrite-choice button {
    flex: 1;
    min-height: 0;
  }
  .overwrite-choice svg {
    width: 28px;
    height: 28px;
    stroke-width: 2.4;
  }
  /* red and dark in turn, the icon always readable */
  .overwrite-choice .confirm {
    color: var(--text);
    border-color: var(--status-error);
    background: var(--status-error);
    animation: blink 1s steps(2, jump-none) infinite;
  }
  .overwrite-choice .cancel.cancelling {
    color: var(--bg);
    border-color: var(--text);
    background: var(--text);
  }
  @keyframes blink {
    50% {
      color: var(--status-error);
      background: var(--panel-2);
    }
  }
  @media (orientation: portrait) {
    .overwrite-choice {
      flex-direction: row;
    }
  }
  @media (prefers-reduced-motion: reduce) {
    .overwrite-choice button {
      animation: none;
    }
  }
  /* over the list and controls, the page blurred behind; touches go through */
  .body {
    position: relative;
  }
  /* above the list, under the drawers (z-index 1): the buttons stay sharp */
  .overwrite-info {
    position: absolute;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    padding: var(--space-3) 0 var(--space-3) var(--space-5);
    background: color-mix(in srgb, var(--bg) 30%, transparent);
    backdrop-filter: blur(6px);
    -webkit-backdrop-filter: blur(6px);
  }
  .overwrite-info .card {
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
    padding: var(--space-4) var(--space-5);
    background: var(--panel);
    border: 1px solid var(--status-error);
    border-radius: calc(var(--radius) * 2);
    box-shadow: 0 8px 32px rgb(0 0 0 / 0.6);
    width: min(560px, 100%);
  }
  /* landscape: clear of the side column floating over the list's edge */
  @media (orientation: landscape) {
    .overwrite-info .card {
      width: min(560px, 100% - var(--side) - var(--space-2) - var(--space-5));
    }
    :global(:root[data-island="right"]) .overwrite-info .card {
      margin-left: calc(var(--side) + var(--space-2));
      margin-right: var(--space-5);
    }
  }
  .overwrite-info .label {
    font-size: var(--text-name);
    color: var(--text-muted);
  }
  /* the name is what matters: big, on its own line */
  .overwrite-info .name {
    font-size: var(--text-scene);
    font-weight: 600;
    line-height: 1.15;
    color: var(--status-error);
    overflow-wrap: anywhere;
  }
  /* the store's outcome, for a moment */
  .store.saved {
    color: var(--status-live);
    border-color: var(--status-live);
    background: color-mix(in srgb, var(--status-live) 12%, var(--panel-2));
  }
  .store.failed {
    color: var(--status-error);
    border-color: var(--status-error);
    background: color-mix(in srgb, var(--status-error) 12%, var(--panel-2));
  }
  .side .store.storing {
    filter: brightness(1.3);
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

  .list {
    flex: 1;
    min-height: 0;
    margin: 0;
    padding: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
    position: relative; /* rows' offsetTop is measured from here */
    overflow-y: auto;
    overscroll-behavior: contain;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
    /* fade rows out at the edges instead of cutting them off */
    mask-image: linear-gradient(transparent, #000 var(--space-5), #000 calc(100% - var(--space-5)), transparent);
  }
  .list > li {
    flex: none; /* scroll, don't squeeze */
  }
  .list::-webkit-scrollbar {
    display: none;
  }
  /* room to centre the first and last scenes */
  .list::before,
  .list::after {
    content: "";
    flex: none;
    height: 40%;
  }
  .row {
    display: flex;
    align-items: center;
    gap: var(--space-3);
    width: 100%;
    height: var(--scene-row);
    padding: 0 var(--space-3) 0 0;
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text-muted);
    font-size: var(--text-name);
    text-align: left;
    overflow: hidden;
    transition:
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      color var(--motion) var(--ease),
      font-size var(--motion) var(--ease),
      filter var(--motion) var(--ease);
  }
  .strip {
    align-self: stretch;
    width: 6px;
    flex: none;
    opacity: 0.8;
  }
  .row.fired {
    color: var(--text);
  }
  .row.selected {
    color: var(--text);
    font-size: var(--text-scene);
    background: color-mix(in srgb, var(--accent-select) 10%, var(--panel));
    border-color: var(--accent-select);
  }
  .row.selected .strip {
    width: 10px;
    opacity: 1;
  }
  .title {
    flex: 1;
    min-width: 0;
    display: flex;
    align-items: baseline;
    gap: var(--space-2);
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

  .controls {
    display: grid;
    grid-template-columns: 1fr 2fr 1.5fr 1fr;
    gap: var(--space-2);
  }
  .controls button {
    min-height: calc(var(--touch) * 1.5);
    background: var(--panel-2);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text);
    font-size: var(--text-body);
  }
  .controls .fire {
    border-color: var(--accent-on);
    background: color-mix(in srgb, var(--accent-on) 12%, var(--panel-2));
    font-size: var(--text-name);
    letter-spacing: 0.04em;
  }
  .controls .fire-stop {
    font-size: var(--text-label);
    letter-spacing: 0.04em;
  }
  /* Disabled buttons swallow touches in some browsers; let the waking touch through */
  .row.passive {
    pointer-events: none;
  }
  .controls button:disabled,
  .row:disabled:not(.passive) {
    opacity: 0.4;
  }

  /* Portrait: the outer corners follow the screen's rounded corners (concentric,
     about the screen radius minus the content inset), so they aren't clipped */
  /* phones only: iPad corners are much smaller */
  @media (orientation: portrait) and (max-width: 500px) {
    .controls .prev {
      border-bottom-left-radius: var(--corner-concentric);
    }
    .controls .next {
      border-bottom-right-radius: var(--corner-concentric);
    }
  }
  /* Landscape phones: the side column meets the outer bottom corner (away from the island) */
  @media (orientation: landscape) and (max-height: 500px) {
    :global(:root:not([data-island="right"])) .stop {
      border-bottom-right-radius: var(--corner-concentric);
    }
    :global(:root[data-island="right"]) .stop {
      border-bottom-left-radius: var(--corner-concentric);
    }
    /* the rows scrolling past that corner are clipped to the same curve */
    :global(:root:not([data-island="right"])) .list {
      border-bottom-right-radius: var(--corner-concentric);
    }
    :global(:root[data-island="right"]) .list {
      border-bottom-left-radius: var(--corner-concentric);
    }
  }

  /* Portrait: the preset goes under the scene name */
  @media (orientation: portrait) {
    .title {
      flex-direction: column;
      align-items: flex-start;
      gap: 0;
    }
    .title > * {
      max-width: 100%;
    }
    .preset {
      min-width: 0;
      align-self: flex-end;
    }
  }

  /* Portrait: the side column becomes a row above the list */
  @media (orientation: portrait) {
    .scenes,
    :global(:root[data-island="right"]) .scenes {
      flex-direction: column-reverse;
    }
    .scenes {
      --drawer-gap: var(--space-2);
    }
    .side,
    :global(:root[data-island="right"]) .side {
      position: static;
      width: auto;
    }
    .scenes.open .list > li,
    :global(:root[data-island="right"]) .scenes.open .list > li {
      padding: 0;
    }
    .controls,
    :global(:root[data-island="right"]) .controls {
      margin: 0;
    }
    .side-buttons {
      flex-direction: row;
    }
    .side button,
    .side .play,
    .side .stop,
    .side .metronome {
      width: auto;
      height: var(--touch);
      writing-mode: horizontal-tb;
    }
  }

  /* Inverted landscape: the rotated label reads the other way, mirroring it (only
     the text: the button stays as it is) */
  @media (orientation: landscape) {
    :global(:root[data-island="right"]) .store .text {
      display: inline-block;
      rotate: 180deg;
    }
  }
</style>
