<script lang="ts">
  import { appState, health, liveConnected, link, synced } from "./lib/state";

  let showJson = $state(false);

  const labels = { live: "live", reconnecting: "reconnecting", offline: "Live offline" } as const;
  const pageNames = ["transport", "loops", "favorites"];

  let pageName = $derived($appState.page === undefined ? "-" : (pageNames[$appState.page] ?? String($appState.page)));
  let banner = $derived(
    $link !== "open" ? "Hub unreachable, reconnecting..." : $synced && !$liveConnected ? "Hub is up, but Live is disconnected. Showing last known state." : "",
  );
</script>

<div class="shell">
  <header>
    <span class="dot {$health}" title={labels[$health]}></span>
    <span class="label">{labels[$health]}</span>
    <span class="sep"></span>
    <span class="item">page <b>{pageName}</b></span>
    <span class="item">mode <b>{$appState.mode ?? "-"}</b></span>
    <span class="item"><b>{$appState.tempo !== undefined ? $appState.tempo.toFixed(1) : "-"}</b> bpm</span>
    <span class="item" class:warn={$appState.pedalboard && !$appState.pedalboard.found}>
      pedalboard <b>{$appState.pedalboard ? ($appState.pedalboard.found ? "found" : "missing") : "-"}</b>
    </span>
  </header>

  {#if banner}
    <div class="banner" class:amber={$link !== "open"} role="status">{banner}</div>
  {/if}

  <main>
    <div class="placeholder">
      <div class="label">mode</div>
      <div class="mode">{$appState.mode ?? "-"}</div>
    </div>

    <details bind:open={showJson}>
      <summary>raw state</summary>
      {#if showJson}<pre>{JSON.stringify($appState, null, 2)}</pre>{/if}
    </details>
  </main>
</div>

<style>
  .shell {
    display: flex;
    flex-direction: column;
    height: 100%;
  }
  header {
    display: flex;
    align-items: center;
    gap: var(--space-3);
    padding: calc(var(--space-2) + var(--safe-top)) var(--space-3) var(--space-2);
    background: var(--panel);
    border-bottom: 1px solid var(--border);
    font-size: var(--text-label);
    color: var(--text-muted);
    white-space: nowrap;
    flex-wrap: wrap;
    row-gap: var(--space-1);
  }
  header b {
    color: var(--text);
    font-weight: 500;
  }
  .sep {
    flex: 1;
  }
  .dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: var(--text-muted);
    flex: none;
  }
  .dot.live {
    background: var(--status-live);
  }
  .dot.reconnecting {
    background: var(--status-reconnecting);
  }
  .dot.offline {
    background: var(--status-error);
  }
  .warn b {
    color: var(--status-reconnecting);
  }
  .banner {
    padding: var(--space-2) var(--space-3);
    background: var(--panel-2);
    border-bottom: 1px solid var(--status-error);
    font-size: var(--text-label);
  }
  .banner.amber {
    border-bottom-color: var(--status-reconnecting);
  }
  main {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    overscroll-behavior: contain;
    padding: var(--space-4) var(--space-3);
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
</style>
