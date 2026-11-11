import { derived, get, writable } from "svelte/store";
import type { Connection, SocketStatus, Retry } from "./connection";

/** The state tree of protocol/frontend.md section 3. Fields are optional: missing == null. */
export interface FcState {
  version?: string;
  page?: number;
  mode?: string;
  tempo?: number;
  pedalboard?: { found: boolean; track?: string; track_index?: number; device?: string; device_index?: number };
  transport?: { playing: boolean; metronome: boolean };
  scenes?: Scenes;
  loops?: Loop[];
  edit?: Record<string, unknown>;
  presets?: Record<string, unknown>;
  tuner?: Tuner;
  hub?: { live_connected: boolean };
  [key: string]: unknown;
}

/** Present only while the volume is 0 (protocol/frontend.md, `tuner`). */
export interface Tuner {
  note: string;
  cents: number;
  in_tune: boolean;
}

export interface Scene {
  index: number;
  name: string;
  color: number;
}

export interface Scenes {
  count: number;
  selected: number;
  fired: Scene | null;
  window: Scene[];
}

export interface Parameter {
  parameter: number;
  name: string;
  value: number;
  display: string;
}

export interface Loop {
  index: number;
  pedal: number;
  name: string;
  on: boolean;
  chain: string;
  chains: string[];
  favorite: Parameter | null;
}

export type Changes = Record<string, unknown>;

type Container = Record<string, unknown> | unknown[];

const clone = <T>(v: T): T => structuredClone(v);

/**
 * Apply `state.changed` in place; mirrors apply_changes in src/ui_protocol.py.
 * Paths are dotted, lists are indexed by number, null deletes an object key
 * (but stays in a list, so indices don't shift). A path whose parent is
 * missing is ignored (logged); the next dump resyncs.
 */
export function applyChanges(state: FcState, changes: Changes): void {
  const paths = Object.keys(changes).sort((a, b) => a.split(".").length - b.split(".").length);
  for (const path of paths) {
    const segs = path.split(".");
    const last = segs.pop()!;
    let node: unknown = state;
    for (const s of segs) {
      node = (node as Container | undefined)?.[s as never];
      if (node === undefined || node === null || typeof node !== "object") break;
    }
    if (node === undefined || node === null || typeof node !== "object") {
      console.warn("state.changed: unknown parent for", path);
      continue;
    }
    const value = clone(changes[path]);
    if (Array.isArray(node)) {
      const i = Number(last);
      if (!Number.isInteger(i) || i < 0 || i > node.length || (i === node.length && value === null)) {
        console.warn("state.changed: bad list index in", path);
        continue;
      }
      node[i] = value;
    } else if (value === null) {
      delete (node as Record<string, unknown>)[last];
    } else {
      (node as Record<string, unknown>)[last] = value;
    }
  }
}

export const appState = writable<FcState>({});
/** The WebSocket to the hub (not Ableton Link). */
export const socket = writable<SocketStatus>("closed");
/** The pending reconnect while the hub is unreachable. */
export const retry = writable<Retry | null>(null);
/** True once the first dump has arrived on the current connection. */
export const synced = writable(false);

/** The hub's link to the Remote Script inside Ableton Live (protocol: hub.live_connected). */
export const abletonConnected = derived(appState, ($s) => $s.hub?.live_connected === true);

export type Outage = "hub" | "ableton" | "connecting" | "pedalboard";

/** Development: VITE_FORCE_OUTAGE=hub|ableton|connecting|pedalboard shows that warning regardless. */
const forced = import.meta.env.VITE_FORCE_OUTAGE as Outage | undefined;

/** What is down, or null when healthy: the hub (the WebSocket, so also Wi-Fi), Ableton
 *  Live behind a hub that is up, the first state hasn't arrived yet, or Ableton Live is
 *  up but the set has no pedalboard device. */
export const outage = derived([socket, synced, abletonConnected, appState], ([$socket, $synced, $ableton, $s]): Outage | null => {
  if (forced) return forced;
  if ($socket !== "open") return "hub";
  if (!$synced) return "connecting";
  if (!$ableton) return "ableton";
  return $s.pedalboard?.found === false ? "pedalboard" : null;
});

if (forced === "hub") {
  // fake a reconnect schedule so the counter can be seen ticking
  let attempt = 0;
  const next = () => {
    const delay = Math.min(250 * 2 ** attempt, 5000);
    retry.set({ attempt: ++attempt, at: Date.now() + delay });
    setTimeout(next, delay);
  };
  next();
}

export function applyDump(dump: FcState): void {
  appState.set(clone(dump));
  synced.set(true);
}

export function applyStateChanged(changes: Changes): void {
  appState.update((s) => {
    const next = clone(s);
    applyChanges(next, changes);
    return next;
  });
}

export function bind(conn: Connection): void {
  conn.onStatus((s) => {
    socket.set(s);
    if (s !== "open") synced.set(false);
  });
  conn.onRetry((r) => retry.set(r));
  conn.on("state.dump", (d) => applyDump(d as FcState));
  conn.on("state.changed", (d) => applyStateChanged(d as Changes));
  conn.on("hub.status", (d) => {
    const live = (d as { live_connected: boolean }).live_connected;
    appState.update((s) => ({ ...s, hub: { live_connected: live } }));
  });
}

export const snapshot = (): FcState => get(appState);
