import { remembered } from "./pages";

/** Show the tuner bar while the volume is 0; per device, set in the page menu. */
export const tunerBar = remembered("fc200.tunerBar", true);

/** In tune within ±TOLERANCE cents: src/config.py TUNER_TOLERANCE, for drawing only
 *  (`tuner.in_tune` comes from the script). */
export const TOLERANCE = 2;

/** Cents to the fill's half-width share, -1..1 (the tuner reads about ±50). */
export function offset(cents: number): number {
  return Math.max(-1, Math.min(1, cents / 50));
}

/** Green in tune, red at ±25 cents and beyond. Stays green for most of the way
 *  and passes yellow only briefly. */
export function hue(cents: number): number {
  return 130 * Math.sqrt(1 - Math.min(1, Math.abs(cents) / 25));
}

/** Darker the closer to 0 cents: 34% in tune, up to 42% at ±25 cents
 *  (low enough that the yellow in between reads as olive). */
export function lightness(cents: number): number {
  return 34 + 8 * Math.min(1, Math.abs(cents) / 25);
}
