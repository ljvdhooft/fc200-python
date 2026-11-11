/**
 * Mark which side the Dynamic Island / notch is on in landscape, so only that side
 * keeps its safe-area inset (see tokens.css). On iOS "landscape-primary" means the
 * top of the phone points left.
 */
export function trackIsland(): void {
  const update = () => {
    const type = screen.orientation?.type ?? "";
    document.documentElement.dataset.island =
      type === "landscape-primary" ? "left" : type === "landscape-secondary" ? "right" : "none";
  };
  update();
  screen.orientation?.addEventListener("change", update);

  // iOS scrolls the page by the status-bar height while rotating; with scrolling off
  // it never comes back and every touch lands that far off. Put it back after the
  // rotation has settled.
  const unscroll = () => {
    if (window.scrollX || window.scrollY) window.scrollTo(0, 0);
  };
  window.addEventListener("resize", () => requestAnimationFrame(unscroll));
  window.addEventListener("scroll", unscroll);
}
