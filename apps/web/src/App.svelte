<script lang="ts">
  import { appState, outage } from "./lib/state";
  import { interactive } from "./lib/touch";
  import { follow, localPage, PAGES, shownPage } from "./lib/pages";
  import { fade, fly } from "svelte/transition";
  import { ease, FADE, MOTION } from "./lib/motion";
  import NowPlaying from "./views/NowPlaying.svelte";
  import Scenes from "./views/Scenes.svelte";
  import Loops from "./views/Loops.svelte";
  import Favorite from "./views/Favorite.svelte";
  import Outage from "./views/Outage.svelte";
  import Lock from "./lib/Lock.svelte";
  import TunerBar from "./views/Tuner.svelte";
  import type { Tuner } from "./lib/state";
  import Drawer from "./lib/Drawer.svelte";
  import { tunerBar } from "./lib/tuner";

  let showJson = $state(false);

  let tempo = $derived($appState.tempo === undefined ? "–" : String(Math.round($appState.tempo)));

  // Short names for the rail's page button
  const SHORT = { scenes: "scn", loops: "loop", favorites: "fav" } as const;

  // Portrait: the rail becomes a bar along the top and the menu drops down
  const portraitQuery = matchMedia("(orientation: portrait)");
  let portrait = $state(portraitQuery.matches);
  portraitQuery.addEventListener("change", (e) => (portrait = e.matches));

  // The tuner node goes as soon as the volume is up: keep the last reading so the
  // drawer slides out with it instead of closing empty
  let lastTuner = $state<Tuner | undefined>();
  $effect(() => {
    if ($appState.tuner) lastTuner = $appState.tuner;
  });

  // Pages whose touch-mode controls slide in over the tuner bar (Scenes' bottom
  // drawer): the bar stays under them. Elsewhere (loops: the presets button stays)
  // the bar slides away with touch mode: tuning and the controls don't go together.
  const COVERED_PAGES = new Set([0]);
  let tunerOpen = $derived(
    !!($tunerBar && $appState.tuner) && (COVERED_PAGES.has($shownPage) || !$interactive),
  );

  let menuOpen = $state(false);
  // The menu goes when touch mode ends (not before it starts: the page button opens
  // the menu on the touch that wakes the page) or when following starts again
  interactive.subscribe((on) => {
    if (!on) menuOpen = false;
  });
  $effect(() => {
    if ($follow) menuOpen = false;
  });

  function toggleFollow() {
    // Stopping: stay on the page that is showing now
    if ($follow) localPage.set($shownPage);
    follow.update((on) => !on);
  }

  function choose(page: number) {
    localPage.set(page);
    menuOpen = false;
  }
</script>

{#if $outage}
  <!-- Something is down: nothing else on screen, just what -->
  <Outage />
{:else}
<div class="shell">
  <!-- Landscape: a rail in the strip next to the Dynamic Island. Portrait: a bar along
       the top, health on the left, page and follow on the right -->
  <aside class="rail">
    <!-- Only shown while everything is connected (otherwise the Outage screen) -->
    <div class="status" title="hub and Ableton Live connected">
      <span class="dot"></span>
      <span class="tempo">{tempo}</span>
      <span class="unit">bpm</span>
    </div>

    <!-- Portrait: the padlock sits in the middle of the bar (in landscape it's at
         the end of "now playing": the rail is the Dynamic Island's) -->
    {#if portrait}<span class="lock"><Lock /></span>{/if}

    <div class="pages">
      {#if !$follow}
        <!-- Persistent while not following: shows the page, opens the page menu -->
        <button
          class="page"
          class:open={menuOpen}
          data-always
          onclick={() => (menuOpen = !menuOpen)}
          aria-haspopup="menu"
          aria-expanded={menuOpen}
          transition:fade={{ duration: FADE }}
        >
          {SHORT[PAGES[$shownPage]] ?? $shownPage}
        </button>
        {#if menuOpen}
          <!-- tapping anywhere else closes the menu -->
          <button class="backdrop" aria-label="close" onclick={() => (menuOpen = false)}></button>
          <div class="menu" role="menu" transition:fly={portrait ? { y: -8, duration: MOTION, easing: ease } : { x: -8, duration: MOTION, easing: ease }}>
            <!-- page 0 at the bottom, like stepping up through the FC-200's pages -->
            {#each [...PAGES.entries()].reverse() as [page, name] (name)}
              <button role="menuitem" class:current={$shownPage === page} onclick={() => choose(page)}>{name}</button>
            {/each}
            <button
              role="menuitemcheckbox"
              class="setting"
              aria-checked={$tunerBar}
              onclick={() => tunerBar.update((on) => !on)}
            >tuner bar <span class="check">{$tunerBar ? "on" : "off"}</span></button>
          </div>
        {/if}
      {/if}
      <button
        class="follow"
        data-always
        class:on={$follow}
        onclick={toggleFollow}
        aria-pressed={$follow}
        title={$follow ? "following the FC-200 page" : "not following the FC-200 page"}
      >
        <!-- linked chain / broken chain -->
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <!-- Lucide "link" / "unlink" (ISC) -->
          {#if $follow}
            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
          {:else}
            <path d="m18.84 12.25 1.72-1.71a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
            <path d="m5.17 11.75-1.71 1.71a5 5 0 0 0 7.07 7.07l1.71-1.71" />
            <path d="M8 2v3M2 8h3M16 19v3M19 16h3" />
          {/if}
        </svg>
      </button>
    </div>
  </aside>

  <div class="content">
    <NowPlaying />

    <main>
      {#if $shownPage === 0}
        <Scenes />
      {:else if $shownPage === 1 || $shownPage === 2}
        <!-- page 2 (favorites) shows the loops too; a picked favorite goes fullscreen -->
        <Loops />
      {:else}
        <div class="placeholder">
          <div class="label">page</div>
          <div class="mode">{PAGES[$shownPage] ?? $shownPage}</div>
        </div>

        <details bind:open={showJson}>
          <summary>raw state</summary>
          {#if showJson}<pre>{JSON.stringify($appState, null, 2)}</pre>{/if}
        </details>
      {/if}
    </main>

    {#if $shownPage === 2 && $appState.favorite}
      <Favorite favorite={$appState.favorite} />
    {/if}

    <!-- Floats over the bottom of the page: it never resizes the scene list -->
    <div class="tuner-slot">
      <Drawer open={tunerOpen} edge="overlay">
        {#if lastTuner}<TunerBar tuner={lastTuner} />{/if}
      </Drawer>
    </div>
  </div>
</div>
{/if}

<style>
  .shell {
    display: flex;
    height: 100%;
  }
  /* Rail on the Dynamic Island side: it uses the space the island leaves free */
  :global(:root[data-island="right"]) .shell {
    flex-direction: row-reverse;
  }
  .rail {
    flex: none;
    width: var(--rail);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    /* the bottom corner is rounded: lift the follow button clear of the curve */
    padding: max(calc(var(--space-3) + var(--safe-top)), 28px) 0 max(var(--inset-bottom), 28px);
  }
  .content {
    flex: 1;
    min-width: 0;
    min-height: 0; /* portrait stacks it under the bar: don't grow past the screen */
    display: flex;
    flex-direction: column;
    gap: var(--space-3);
    padding: calc(var(--space-2) + var(--safe-top)) var(--inset-content) 0 0;
  }
  :global(:root[data-island="right"]) .content {
    padding-left: var(--inset-content);
    padding-right: 0;
  }

  .status {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: var(--space-1);
  }
  .tempo {
    margin-top: var(--space-1);
    font-size: var(--text-name);
    line-height: 1;
    color: var(--text);
    font-variant-numeric: tabular-nums;
  }
  .unit {
    font-size: 9px;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--text-muted);
  }
  .dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: var(--status-live);
    animation: breathe 4s ease-in-out infinite;
  }
  /* Slow, calm "all good"; a static dot means something needs attention */
  @keyframes breathe {
    0%,
    100% {
      opacity: 0.45;
      box-shadow: 0 0 0 0 transparent;
    }
    50% {
      opacity: 1;
      box-shadow: 0 0 8px 1px color-mix(in srgb, var(--status-live) 45%, transparent);
    }
  }
  @media (prefers-reduced-motion: reduce) {
    .dot {
      animation: none;
    }
  }

  .pages {
    position: relative; /* anchors the menu */
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: var(--space-2);
  }
  .rail .page.open {
    color: var(--text);
    border-color: var(--accent-select);
  }
  .rail .backdrop {
    position: fixed;
    inset: 0;
    width: auto;
    z-index: 10;
    background: transparent;
    border: 0;
  }
  /* Opens beside the rail, towards the content; its bottom lines up with the page button */
  .menu {
    position: absolute;
    left: calc(100% + var(--space-2));
    bottom: calc(var(--touch) + var(--space-2));
    z-index: 11;
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
    padding: var(--space-1);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: calc(var(--radius) * 2);
    box-shadow: 0 8px 24px rgb(0 0 0 / 0.5);
  }
  :global(:root[data-island="right"]) .menu {
    left: auto;
    right: calc(100% + var(--space-2));
  }
  .rail .menu button {
    width: auto;
    min-width: 128px;
    padding: 0 var(--space-3);
    font-size: var(--text-body);
    letter-spacing: 0;
    text-transform: none;
    text-align: left;
    color: var(--text-muted);
    background: none;
    border-color: transparent;
  }
  .rail button {
    width: var(--touch);
    min-width: 0;
    padding: 0;
    font-size: 10px;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: var(--text-muted);
    background: var(--panel);
  }
  .rail .menu .setting {
    display: flex;
    justify-content: space-between;
    gap: var(--space-3);
    border-top: 1px solid var(--border);
    border-radius: 0;
  }
  .setting .check {
    color: var(--text-muted);
  }
  .setting[aria-checked="true"] .check {
    color: var(--accent-on);
  }
  .rail .menu button.current {
    color: var(--text);
    background: color-mix(in srgb, var(--accent-select) 12%, var(--panel));
    border-color: var(--accent-select);
  }
  .rail .follow {
    display: grid;
    place-items: center;
    background: none;
    border-color: transparent;
    color: var(--status-error);
  }
  .follow.on {
    color: var(--follow);
  }
  .follow svg {
    width: 24px;
    height: 24px;
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
    filter: drop-shadow(0 0 4px color-mix(in srgb, currentColor 70%, transparent));
    transition: color var(--motion) var(--ease);
  }

  /* The content box's bottom edge, for the tuner overlay (no extra gap) */
  .tuner-slot {
    position: relative;
    height: 0;
    margin-top: calc(-1 * var(--space-3));
  }

  main {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    overscroll-behavior: contain;
    padding-bottom: var(--inset-bottom);
  }
  .placeholder {
    padding: var(--space-5) 0;
  }
  .label {
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  .mode {
    font-size: var(--text-name);
  }
  summary {
    min-height: var(--touch);
    display: flex;
    align-items: center;
    color: var(--text-muted);
    font-size: var(--text-label);
  }
  pre {
    margin: 0;
    padding: var(--space-3);
    background: var(--panel);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    font: 11px/1.4 var(--font-mono);
    user-select: text;
    -webkit-user-select: text;
    overflow-x: auto;
  }

  @media (orientation: portrait) {
    .shell,
    :global(:root[data-island="right"]) .shell {
      flex-direction: column;
    }
    .rail {
      width: auto;
      flex-direction: row;
      /* As a home-screen app the page starts below iOS's opaque status bar (the
         see-through one is broken on iOS 26: blur on top, an empty strip at the
         bottom). Even padding keeps the bar from looking pinned to that edge. */
      padding: calc(var(--space-2) + var(--safe-top)) var(--inset-content) var(--space-1);
    }
    .content,
    :global(:root[data-island="right"]) .content {
      padding: 0 var(--inset-content);
    }
    .status {
      flex-direction: row;
      align-items: baseline;
      gap: var(--space-2);
    }
    .dot {
      align-self: center;
    }
    .rail {
      position: relative; /* anchors the padlock */
    }
    /* centred on the screen, whatever the widths on either side */
    .lock {
      position: absolute;
      left: 50%;
      /* the bar's padding box, vertically centred in it */
      top: calc(var(--space-2) + var(--safe-top));
      bottom: var(--space-1);
      margin-block: auto;
      translate: -50% 0;
      height: 20px;
    }
    .tempo {
      margin-top: 0;
      font-size: var(--text-body);
    }
    .dot {
      width: 10px;
      height: 10px;
    }
    /* smaller to the eye, still a 44 px touch target: the buttons overhang the bar */
    .rail button {
      margin-block: calc((var(--touch) - 32px) / -2);
    }
    .rail .menu button {
      margin-block: 0; /* the overhang is for the bar, not the menu */
    }
    .rail .page {
      height: 32px;
      min-height: 32px;
      margin-block: 0;
    }
    .follow svg {
      width: 20px;
      height: 20px;
    }
    .pages {
      flex-direction: row;
    }
    /* drops down from the bar, right-aligned under the buttons */
    .menu,
    :global(:root[data-island="right"]) .menu {
      left: auto;
      right: 0;
      bottom: auto;
      top: calc(100% + var(--space-2));
    }
  }
</style>
