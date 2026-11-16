<script lang="ts">
  // The display-mode padlock: shown while the page is locked (the first touch only
  // wakes it), with a little locking animation. Its parent places it.
  import { interactive } from "./touch";
  import { fade } from "svelte/transition";
  import { FADE } from "./motion";
</script>

{#if !$interactive}
  <svg class="lock" viewBox="0 0 24 24" aria-label="locked: touch to wake" transition:fade={{ duration: FADE }}>
    <!-- Lucide "lock" (ISC) -->
    <rect x="3" y="11" width="18" height="11" rx="2" />
    <path class="shackle" d="M7 11V7a5 5 0 0 1 10 0v4" />
  </svg>
{/if}

<style>
  .lock {
    display: block;
    width: 20px;
    height: 20px;
    fill: none;
    stroke: var(--text-muted);
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
    opacity: 0.6;
    /* It locks once it has faded in: it starts larger, with the shackle swung up
       off its right leg and the body tilted the other way, then both turn into
       place as it shrinks to size. Everything stays inside its own box: the top
       bar has no room above it. */
    --lock-delay: 260ms; /* FADE in lib/motion.ts: lock after the fade */
    --lock-time: 520ms;
    /* the one place that overshoots: it snaps shut */
    --lock-ease: cubic-bezier(0.34, 1.56, 0.64, 1);
    animation: lock-shrink var(--lock-time) var(--lock-ease) var(--lock-delay) both;
  }
  .lock .shackle {
    transform-origin: 17px 11px; /* the right leg's foot, in viewBox units */
    animation: lock-shackle var(--lock-time) var(--lock-ease) var(--lock-delay) both;
  }
  .lock rect {
    transform-origin: 12px 16px; /* the body's centre */
    animation: lock-body var(--lock-time) var(--lock-ease) var(--lock-delay) both;
  }
  @keyframes lock-shrink {
    from {
      scale: 1.4;
    }
  }
  @keyframes lock-shackle {
    from {
      rotate: 22deg; /* the left leg lifts out; the top stays inside the viewBox */
    }
  }
  @keyframes lock-body {
    from {
      rotate: -10deg;
    }
  }
  @media (prefers-reduced-motion: reduce) {
    .lock,
    .lock .shackle,
    .lock rect {
      animation: none;
    }
  }
</style>
