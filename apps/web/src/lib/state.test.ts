import { readFileSync } from "node:fs";
import { beforeEach, describe, expect, it } from "vitest";
import { get } from "svelte/store";
import { applyChanges, applyDump, applyStateChanged, appState, synced, type FcState } from "./state";

const fixture = (): FcState => JSON.parse(readFileSync("../../protocol/fixtures/dump.json", "utf8"));

describe("applyChanges", () => {
  it("sets nested values by dotted path", () => {
    const s = fixture();
    applyChanges(s, { tempo: 98.5, "transport.playing": true, "loops.0.favorite.value": 0.9 });
    expect(s.tempo).toBe(98.5);
    expect(s.transport?.playing).toBe(true);
    expect((s.loops![0] as any).favorite.value).toBe(0.9);
  });

  it("replaces a list whole", () => {
    const s = fixture();
    applyChanges(s, { "loops.0.chains": ["A"], "scenes.window": [{ index: 1, name: "x", color: 0, preset: null, down: false }] });
    expect((s.loops![0] as any).chains).toEqual(["A"]);
    expect((s.scenes as any).window).toHaveLength(1);
  });

  it("null deletes an object key but stays in a list", () => {
    const s = fixture();
    applyChanges(s, { "scenes.fired": null, "scenes.window.0": null });
    expect("fired" in (s.scenes as object)).toBe(false);
    expect((s.scenes as any).window[0]).toBeNull();
    expect((s.scenes as any).window).toHaveLength(7);
  });

  it("adds an object and appends to a list at index == length", () => {
    const s: FcState = { loops: [] };
    applyChanges(s, { edit: { loop: 1 }, "loops.0": { index: 0 } });
    expect(s.edit).toEqual({ loop: 1 });
    expect(s.loops).toEqual([{ index: 0 }]);
  });

  it("ignores a path whose parent is missing", () => {
    const s: FcState = { tempo: 1 };
    applyChanges(s, { "nope.deeper.x": 1 });
    expect(s).toEqual({ tempo: 1 });
  });

  it("does not alias the incoming change", () => {
    const s: FcState = {};
    const v = { loop: 1 };
    applyChanges(s, { edit: v });
    v.loop = 2;
    expect(s.edit).toEqual({ loop: 1 });
  });
});

describe("store", () => {
  beforeEach(() => {
    appState.set({});
    synced.set(false);
  });

  it("dump replaces the state and marks synced", () => {
    appState.set({ tempo: 1, extra: { a: 1 } });
    applyDump(fixture());
    expect(get(appState).extra).toBeUndefined();
    expect(get(appState).mode).toBe("parameter_control");
    expect(get(synced)).toBe(true);
  });

  it("round-trips a fixture: dump then changes equals expected", () => {
    const fx = fixture();
    applyDump(fx);
    applyStateChanged({ tempo: 130, "loops.1.on": false });
    const s = get(appState);
    expect(s.tempo).toBe(130);
    expect((s.loops![1] as any).on).toBe(false);
    // untouched parts equal the fixture; the fixture object itself is not mutated
    expect(s.scenes).toEqual(fx.scenes);
    expect(fx.tempo).toBe(120);
  });
});
