import { quintOut } from "svelte/easing";

/**
 * Apple-style motion: quick to start, long soft settle, no overshoot. quintOut is
 * the JS twin of tokens.css --ease (cubic-bezier(0.32, 0.72, 0, 1), the curve iOS
 * uses for sheets). Honours "Reduce Motion" in the iOS accessibility settings.
 */
const reduced =
  typeof matchMedia !== "undefined" &&
  matchMedia("(prefers-reduced-motion: reduce)").matches;

export const ease = quintOut;
export const MOTION = reduced ? 0 : 380; // movement: list, controls
export const FADE = reduced ? 0 : 260; // opacity only
export const GLIDE = reduced ? 0 : 200; // the scene list scrolling to the selection
