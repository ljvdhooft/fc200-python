<script lang="ts">
  import { connection } from "../lib/client";
  import { appState, abletonConnected, type Loop } from "../lib/state";
  import { interactive } from "../lib/touch";

  let loops = $derived($appState.loops ?? []);

  // Show a tap at once, like the scene selection: it holds until the script's `on`
  // for that loop changes (or a timeout, if the request got lost)
  let pending = $state<Record<number, { on: boolean; from: boolean }>>({});
  function on(loop: Loop): boolean {
    const p = pending[loop.index];
    return p && p.from === loop.on ? p.on : loop.on;
  }

  function toggle(loop: Loop) {
    const next = !on(loop);
    pending[loop.index] = { on: next, from: loop.on };
    setTimeout(() => delete pending[loop.index], 1000);
    connection.send("loop.set", { loop: loop.index, on: next });
  }

  // Where a loop sits: like the FC-200's floor, pedals 6-10 above 1-5
  const column = (loop: Loop) => ((loop.pedal - 1) % 5) + 1;
  const row = (loop: Loop) => (loop.pedal > 5 ? 1 : 2);
</script>

<section class="loops">
  {#each loops as loop (loop.index)}
    <button
      class="loop"
      class:on={on(loop)}
      class:passive={!$interactive}
      style:--column={column(loop)}
      style:--row={row(loop)}
      disabled={!$abletonConnected || !$interactive}
      onclick={() => toggle(loop)}
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
        <span class="bar" style:--value={loop.favorite.value}></span>
      {/if}
    </button>
  {/each}
</section>

<style>
  .loops {
    display: grid;
    grid-template-columns: repeat(5, minmax(0, 1fr));
    grid-template-rows: repeat(2, minmax(0, 1fr));
    gap: var(--space-2);
    height: 100%;
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
    transition:
      background var(--motion) var(--ease),
      border-color var(--motion) var(--ease),
      color var(--motion) var(--ease);
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
  .on .bar {
    background: var(--accent-on);
    opacity: 0.8;
  }

  .loop:active:not(:disabled) {
    filter: brightness(1.3);
  }
  /* Disabled buttons swallow touches in some browsers; let the waking touch through */
  .loop.passive {
    pointer-events: none;
  }
  .loop:disabled:not(.passive) {
    opacity: 0.4;
  }

  /* Portrait: two columns, in pedal order */
  @media (orientation: portrait) {
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
</style>
