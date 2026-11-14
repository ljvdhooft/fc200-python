<script lang="ts">
  // ← and ✕ on a fullscreen view or menu (the favorite, parameter control, the
  // chain menu). Its parent places it. It keeps its pointer from a drag on the view
  // behind it. `always`: acts on the touch that wakes the page (data-always).
  let {
    glyph,
    label,
    always = false,
    onclick,
  }: { glyph: "←" | "✕"; label: string; always?: boolean; onclick: () => void } = $props();
</script>

<button class="view-button" aria-label={label} data-always={always || undefined} onpointerdown={(e) => e.stopPropagation()} {onclick}>{glyph}</button>

<style>
  .view-button {
    flex: none;
    align-self: center;
    width: var(--touch);
    min-width: 0;
    padding: 0;
    font-size: var(--text-name);
    color: var(--text-muted);
    background: var(--panel);
  }
</style>
