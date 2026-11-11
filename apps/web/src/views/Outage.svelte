<script lang="ts">
  import { onDestroy } from "svelte";
  import { outage, retry } from "../lib/state";

  let what = $derived($outage ?? "connecting");

  // Countdown to the next reconnect
  let now = $state(Date.now());
  const tick = setInterval(() => (now = Date.now()), 250);
  onDestroy(() => clearInterval(tick));
  let seconds = $derived($retry ? Math.max(0, Math.ceil(($retry.at - now) / 1000)) : 0);
</script>

<div class="outage {what}" role="alert">
  <svg viewBox="0 0 24 24" aria-hidden="true">
    {#if what === "pedalboard"}
      <!-- Lucide "search-x" (ISC): looked for the pedalboard, didn't find it -->
      <path d="m13.5 8.5-5 5" />
      <path d="m8.5 8.5 5 5" />
      <circle cx="11" cy="11" r="8" />
      <path d="m21 21-4.3-4.3" />
    {:else if what === "ableton"}
      <!-- Lucide "unplug" (ISC): the hub is up, Ableton Live isn't plugged in -->
      <path d="m19 5 3-3" />
      <path d="m2 22 3-3" />
      <path d="M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z" />
      <path d="M7.5 13.5 10 11" />
      <path d="M10.5 16.5 13 14" />
      <path d="m12 6 6 6 2.3-2.3a2.4 2.4 0 0 0 0-3.4l-2.6-2.6a2.4 2.4 0 0 0-3.4 0Z" />
    {:else}
      <!-- Lucide "wifi-off" (ISC): this device can't reach the hub -->
      <path d="M12 20h.01" />
      <path d="M8.5 16.429a5 5 0 0 1 7 0" />
      <path d="M5 12.859a10 10 0 0 1 5.17-2.69" />
      <path d="M19 12.859a10 10 0 0 0-2.007-1.523" />
      <path d="M2 8.82a15 15 0 0 1 4.177-2.643" />
      <path d="M22 8.82a15 15 0 0 0-11.288-3.764" />
      <path d="m2 2 20 20" />
    {/if}
  </svg>

  {#if what === "hub"}
    <h1>Hub offline</h1>
    <p>No connection to the Mac</p>
    <p class="retry">
      {#if $retry}
        attempt {$retry.attempt}{seconds > 0 ? ` · next in ${seconds} s` : " · connecting…"}
      {:else}
        connecting…
      {/if}
    </p>
  {:else if what === "pedalboard"}
    <h1>Pedalboard not found</h1>
    <p>No <span class="device">FC200 Pedalboard</span> device in this set</p>
  {:else if what === "ableton"}
    <h1>Ableton Live offline</h1>
    <p>Remote Script not responding</p>
  {:else}
    <h1>Connecting…</h1>
  {/if}
</div>

<style>
  .outage {
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    padding: var(--space-5);
    text-align: center;
    animation: appear var(--motion) var(--ease);
  }
  svg {
    width: 48px;
    height: 48px;
    margin-bottom: var(--space-3);
    fill: none;
    stroke: currentColor;
    stroke-width: 1.5;
    stroke-linecap: round;
    stroke-linejoin: round;
    color: var(--status-reconnecting);
  }
  .ableton svg {
    color: var(--status-error);
  }
  .connecting svg {
    color: var(--text-muted);
  }
  h1 {
    margin: 0;
    font-size: var(--text-name);
    font-weight: 500;
  }
  p {
    margin: 0;
    max-width: 32ch;
    color: var(--text-muted);
  }
  /* the exact device name to look for in Live */
  .device {
    color: var(--text);
    white-space: nowrap;
  }
  .retry {
    margin-top: var(--space-2);
    font-size: var(--text-label);
    font-variant-numeric: tabular-nums;
  }
  @keyframes appear {
    from {
      opacity: 0;
    }
  }
</style>
