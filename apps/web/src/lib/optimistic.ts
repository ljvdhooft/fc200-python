import { derived, get, writable, type Readable } from "svelte/store";
import { appState, type FcState } from "./state";

/**
 * Client-side state ahead of Ableton: a tap shows its effect at once. expect()
 * records the value a path will get; `view` is the state with those values laid
 * over it. Each one holds until Ableton reports the same value (confirmed) or
 * until CONFIRM ms pass without that (the request got lost: Ableton's state wins).
 */
export const CONFIRM = 2000;

const expected = writable<Record<string, unknown>>({});
const timers = new Map<string, ReturnType<typeof setTimeout>>();

export function expect(path: string, value: unknown): void {
  expected.update((e) => ({ ...e, [path]: value }));
  clearTimeout(timers.get(path));
  timers.set(path, setTimeout(() => drop(path), CONFIRM));
}

function drop(path: string): void {
  clearTimeout(timers.get(path));
  timers.delete(path);
  expected.update(({ [path]: _, ...rest }) => rest);
}

const read = (state: unknown, path: string): unknown =>
  path.split(".").reduce<unknown>((node, key) => (node as Record<string, unknown> | undefined)?.[key], state);

const same = (a: unknown, b: unknown): boolean => JSON.stringify(a) === JSON.stringify(b);

// Confirmed: Ableton reports what we expected
appState.subscribe((state) => {
  for (const [path, value] of Object.entries(get(expected))) {
    if (same(read(state, path), value)) drop(path);
  }
});

export const view: Readable<FcState> = derived([appState, expected], ([state, e]) => {
  const paths = Object.keys(e);
  if (paths.length === 0) return state;
  const out = structuredClone(state) as Record<string, unknown>;
  for (const path of paths) {
    const keys = path.split(".");
    let node = out;
    for (const key of keys.slice(0, -1)) {
      if (typeof node[key] !== "object" || node[key] === null) node[key] = {};
      node = node[key] as Record<string, unknown>;
    }
    node[keys[keys.length - 1]] = e[path];
  }
  return out as FcState;
});

/** Fires from this client, ahead of Ableton's `scene.fired` event. */
export const localFires = writable(0);
