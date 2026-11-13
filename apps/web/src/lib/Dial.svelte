<script lang="ts">
  // Ableton-style dial: a 270° arc open at the bottom, the needle from the centre.
  // Its parent sets the size (width/height) and may tuck the value into the gap.
  // `dragging`: follows the finger with no glide
  let { value, dragging = false }: { value: number; dragging?: boolean } = $props();

  // From bottom-left (135°) clockwise round to bottom-right (45°), radius 38
  const ARC = "M 23.13 76.87 A 38 38 0 1 1 76.87 76.87";
</script>

<svg class="dial" class:dragging viewBox="0 0 100 100" aria-hidden="true">
  <path class="track" d={ARC} />
  <path class="arc" d={ARC} pathLength="1" stroke-dasharray="{value} 1" />
  <line class="needle" x1="50" y1="50" x2="88" y2="50" style:rotate="{135 + 270 * value}deg" />
</svg>

<style>
  .dial {
    display: block;
    width: 100%;
    height: 100%;
    fill: none;
    stroke-width: 7;
  }
  .track {
    stroke: var(--panel-2);
  }
  .arc {
    stroke: var(--accent-on);
  }
  .needle {
    stroke: var(--text);
    stroke-width: 4;
    stroke-linecap: round;
    transform-origin: 50px 50px;
  }
  .arc,
  .needle {
    transition: all 80ms linear;
  }
  .dragging .arc,
  .dragging .needle {
    transition: none;
  }
</style>
