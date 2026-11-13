<script lang="ts">
  // ← and ✕ on a fullscreen view (the favorite, parameter control). Its parent
  // places it. It keeps its pointer from a drag on the view behind it.
  let { glyph, label, onclick }: { glyph: "←" | "✕"; label: string; onclick: () => void } = $props();
</script>

<button class="view-button" aria-label={label} onpointerdown={(e) => e.stopPropagation()} {onclick}>{glyph}</button>

<style>
  .view-button {
    flex: none;
    width: var(--touch);
    min-width: 0;
    padding: 0;
    font-size: var(--text-name);
    color: var(--text-muted);
    background: var(--panel);
  }
</style>
