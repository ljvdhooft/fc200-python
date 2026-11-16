import { get, writable, type Readable } from "svelte/store";
import { connection } from "./client";
import { localFires, view } from "./optimistic";

/**
 * Whether the fired scene is no longer what's playing (Now Playing's "last", an
 * unlit LED). Once the transport stops it stays so, also when the transport
 * starts again without firing a scene; firing one makes it playing again.
 * Ahead of Ableton: a fire or play/stop from this client counts at once.
 */
const stopped = writable(true);
export const firedStopped: Readable<boolean> = stopped;

let known = false; // the transport has been reported: from here on, only changes count
view.subscribe((state) => {
  if (!state.transport) return;
  if (!known) stopped.set(!state.transport.playing);
  else if (!state.transport.playing) stopped.set(true);
  known = true;
});
// Every fire, also of the same scene again, comes as a `scene.fired` event
// (resuming the transport doesn't count). Firing starts the transport, so don't
// wait for `playing`: it may arrive in a later change.
connection.on("scene.fired", () => stopped.set(false));
let fires = get(localFires);
localFires.subscribe((n) => {
  if (n !== fires) stopped.set(false);
  fires = n;
});
