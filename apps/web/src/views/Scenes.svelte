<script lang="ts">
  import { connection } from "../lib/client";
  import { appState, abletonConnected, type Scene } from "../lib/state";
  import { interactive, keepInteractive, session, wake } from "../lib/touch";
  import { fade } from "svelte/transition";
  import { ease, FADE, GLIDE } from "../lib/motion";
  import { hex, number } from "../lib/scene";

  let scenes = $derived($appState.scenes);
  let serverSelected = $derived($appState.scenes?.selected ?? -1);
  let fired = $derived(scenes?.fired ?? null);
  let count = $derived(scenes?.count ?? 0);

  // Show a tapped selection at once. It remembers the script's value it was based
  // on, so any new `scenes.selected` from the script replaces it (or a timeout, if
  // the request got lost).
  let pending = $state<{ index: number; from: number } | null>(null);
  let pendingTimer: ReturnType<typeof setTimeout> | undefined;
  let selected = $derived(pending && pending.from === serverSelected ? pending.index : serverSelected);

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
  $effect(() => {
    selected;
    rows.length;
    if (!browsing) centre(true);
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
    pending = { index, from: serverSelected };
    clearTimeout(pendingTimer);
    pendingTimer = setTimeout(() => (pending = null), 1000);
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

  function fire() {
    // Fire launches the selected scene and selects the next one
    browse = null;
    if (selected + 1 < count) optimistic(selected + 1);
    connection.send("scene.fire");
  }
</script>

<section class="scenes">

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
          <span class="name">{scene.name}</span>
          {#if scene.index === fired?.index}<span class="led" title="playing" transition:fade={{ duration: FADE }}></span>{/if}
        </button>
      </li>
    {/each}
  </ol>

  <!-- Always in the layout: its height animates with the slide, so the list
       re-centres in the same motion instead of jumping when the slide ends -->
  <div class="drawer" class:open={$interactive} inert={!$interactive}>
  <div class="controls">
    <button class="prev" disabled={!$abletonConnected || selected <= 0} onclick={() => step(selected - 1)}>◀ prev</button>
    <button class="fire" disabled={!$abletonConnected || selected < 0} onclick={fire}>
      fire
    </button>
    <button class="next" disabled={!$abletonConnected || selected >= count - 1} onclick={() => step(selected + 1)}>next ▶</button>
  </div>
  </div>
</section>

<style>
  .scenes {
    display: flex;
    flex-direction: column;
    gap: var(--space-3);
    height: 100%;
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
    font-size: var(--text-body);
    text-align: left;
    overflow: hidden;
    transition:
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      color var(--motion) var(--ease),
      font-size var(--motion) var(--ease);
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
  .row .name {
    flex: 1;
  }

  .drawer {
    display: grid;
    grid-template-rows: 0fr;
    margin-top: calc(-1 * var(--space-3)); /* cancel the section gap while closed */
    opacity: 0;
    transform: translateY(16px);
    transition:
      grid-template-rows var(--motion) var(--ease),
      margin-top var(--motion) var(--ease),
      opacity var(--motion) var(--ease),
      transform var(--motion) var(--ease);
  }
  .drawer.open {
    grid-template-rows: 1fr;
    margin-top: 0;
    opacity: 1;
    transform: none;
  }
  .controls {
    min-height: 0;
    overflow: hidden;
    display: grid;
    grid-template-columns: 1fr 2fr 1fr;
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
  .controls button:active:not(:disabled),
  .row:active:not(:disabled) {
    filter: brightness(1.3);
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
  /* Landscape phones: the outer bottom corner (away from the island) meets the screen corner */
  @media (orientation: landscape) and (max-height: 500px) {
    :global(:root:not([data-island="right"])) .controls .next {
      border-bottom-right-radius: var(--corner-concentric);
    }
    :global(:root[data-island="right"]) .controls .prev {
      border-bottom-left-radius: var(--corner-concentric);
    }
  }
</style>
