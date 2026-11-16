<script lang="ts">
  import { abletonConnected, appState, socket } from "../lib/state";

  // What the status dot sums up, one line each (next to the tempo pad). Anything
  // down replaces the whole screen (Outage), so here it is mostly all good.
  let hub = $derived($socket === "open");
  let pedalboard = $derived($appState.pedalboard);
</script>

<section class="health" aria-label="health">
  <span class="label">health</span>
  <dl>
    <div class:ok={hub}>
      <dt><span class="dot"></span>hub</dt>
      <dd>{hub ? location.host : $socket}</dd>
    </div>
    <div class:ok={$abletonConnected}>
      <dt><span class="dot"></span>Ableton Live</dt>
      <dd>{$abletonConnected ? "connected" : "not connected"}</dd>
    </div>
    <div class:ok={pedalboard?.found}>
      <dt><span class="dot"></span>pedalboard</dt>
      <dd>
        {#if pedalboard?.found}
          {pedalboard.device} · track {(pedalboard.track_index ?? 0) + 1} {pedalboard.track}
        {:else}
          not found
        {/if}
      </dd>
    </div>
    <div class="ok">
      <dt><span class="dot info"></span>protocol</dt>
      <dd>{$appState.version ?? "–"}</dd>
    </div>
  </dl>
</section>

<style>
  .health {
    width: min(280px, calc(100vw - 2 * var(--space-4)));
    display: flex;
    flex-direction: column;
    gap: var(--space-2);
    padding: var(--space-3);
    /* quiet: no panel, just text on the blurred page beside the pad */
    opacity: 0.75;
    pointer-events: none; /* a tap on it is a tap on the page around the pad: closes */
  }
  .label {
    font-size: var(--text-label);
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.08em;
  }
  dl {
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: var(--space-1);
  }
  dt {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    font-size: var(--text-label);
    color: var(--text-muted);
  }
  dd {
    margin: 0 0 0 calc(6px + var(--space-2)); /* under the name, past the dot */
    font-size: 11px;
    color: color-mix(in srgb, var(--text-muted) 70%, transparent);
    overflow-wrap: anywhere;
  }
  .dot {
    width: 6px;
    height: 6px;
    flex: none;
    border-radius: 50%;
    background: var(--status-error);
  }
  .ok .dot {
    background: var(--status-live);
  }
  /* information, not a status */
  .dot.info {
    background: var(--follow);
  }
</style>
