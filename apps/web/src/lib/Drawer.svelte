<script lang="ts">
  import type { Snippet } from "svelte";

  // Controls that come with touch mode. One animation for every edge: the drawer
  // grows open (so the content beside it moves along in the same motion) and its
  // content rides with the growing edge, sliding out of the screen edge.
  //   bottom: under the content, growing upwards
  //   side:   in landscape a column at the outer edge that doesn't grow (its parent
  //           floats it over the content: a list must not change width under the
  //           finger, iOS cancels the scroll); in portrait a row on top, growing down
  //   overlay: grows up like bottom, but floats over the bottom of its positioned
  //           parent instead of taking room
  // bottom and side are opaque and stack above an overlay: they slide in over it
  // and hide it completely, so an overlay can stay open under them.
  let { open, edge, children }: { open: boolean; edge: "bottom" | "side" | "overlay"; children: Snippet } =
    $props();
</script>

<div class="drawer {edge}" class:open inert={!open}>
  <div class="inner">{@render children()}</div>
</div>

<style>
  .drawer {
    --drawer-slide: 16px;
    display: grid;
    opacity: 0;
    transition:
      grid-template-rows var(--motion) var(--ease),
      margin var(--motion) var(--ease),
      opacity var(--motion) var(--ease),
      transform var(--motion) var(--ease);
  }
  .drawer.open {
    opacity: 1;
    transform: none;
    margin: 0;
  }
  .inner {
    min-width: 0;
    min-height: 0;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }
  .inner > :global(*) {
    flex: none; /* its own size: the drawer clips it while it grows */
  }

  /* Growing open: the track goes from 0 to the content's height. The content sits
     against the inner edge, so it moves with it (a slide, not a curtain). The
     negative margin cancels the parent's gap while closed (--drawer-gap). */
  .drawer {
    grid-template-rows: 0fr;
  }
  .drawer.open {
    grid-template-rows: 1fr;
  }
  .bottom,
  .overlay {
    margin-top: calc(-1 * var(--drawer-gap, 0px));
    transform: translateY(var(--drawer-slide));
  }

  /* Opaque, above overlays (which come later in the page, at z-index 0) */
  .bottom,
  .side {
    position: relative;
    z-index: 1;
  }
  .bottom .inner,
  .side .inner {
    background: var(--bg);
  }

  /* Grows up from the parent's bottom edge without moving anything */
  .overlay {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 0;
    margin: 0;
  }
  .side {
    margin-bottom: calc(-1 * var(--drawer-gap, 0px));
    transform: translateY(calc(-1 * var(--drawer-slide)));
  }
  .side .inner {
    justify-content: flex-end;
  }

  /* Landscape: the side column has the full height and doesn't grow; the content
     slides in from the outer edge (the island's opposite side) */
  @media (orientation: landscape) {
    .side,
    .side.open {
      height: 100%;
      margin: 0;
      grid-template-rows: 1fr;
      overflow: hidden;
      transform: none;
    }
    .side .inner {
      transform: translateX(100%);
      transition: transform var(--motion) var(--ease);
    }
    :global(:root[data-island="right"]) .side .inner {
      transform: translateX(-100%);
    }
    .side.open .inner,
    :global(:root[data-island="right"]) .side.open .inner {
      transform: none;
    }
    .side .inner > :global(*) {
      flex: 1;
    }
  }
</style>
