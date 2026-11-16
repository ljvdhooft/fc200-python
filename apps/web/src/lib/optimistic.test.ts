import { afterEach, describe, expect as want, it, vi } from "vitest";
import { get } from "svelte/store";
import { appState } from "./state";
import { CONFIRM, expect, view } from "./optimistic";

describe("optimistic view", () => {
  afterEach(() => vi.useRealTimers());

  it("shows the expected value at once", () => {
    appState.set({ transport: { playing: false, metronome: true } });
    expect("transport.playing", true);
    want(get(view).transport).toEqual({ playing: true, metronome: true });
    want(get(appState).transport?.playing).toBe(false); // the real state is untouched
  });

  it("hands over to Ableton once it confirms", () => {
    appState.set({ transport: { playing: false, metronome: false } });
    expect("transport.metronome", true);
    appState.set({ transport: { playing: false, metronome: true } }); // confirmed
    appState.set({ transport: { playing: false, metronome: false } }); // the pedal, later
    want(get(view).transport?.metronome).toBe(false);
  });

  it("falls back to Ableton's state when no answer comes", () => {
    vi.useFakeTimers();
    appState.set({ transport: { playing: false, metronome: false } });
    expect("transport.playing", true);
    vi.advanceTimersByTime(CONFIRM);
    want(get(view).transport?.playing).toBe(false);
  });

  it("matches objects by value", () => {
    const scene = { index: 4, name: "Bridge", color: 255 };
    appState.set({ scenes: { count: 9, selected: 4, fired: null, window: [] } });
    expect("scenes.fired", scene);
    appState.set({ scenes: { count: 9, selected: 5, fired: { ...scene }, window: [] } });
    appState.set({ scenes: { count: 9, selected: 5, fired: null, window: [] } });
    want(get(view).scenes?.fired).toBeNull();
  });

  it("doesn't hold a value the state already has, so the next change shows", () => {
    appState.set({ presets: { count: 1, pending_overwrite: null, last: null } });
    expect("presets.pending_overwrite", null); // Ableton was quicker
    appState.set({ presets: { count: 1, pending_overwrite: "Verse", last: null } });
    want(get(view).presets?.pending_overwrite).toBe("Verse");
  });
});
