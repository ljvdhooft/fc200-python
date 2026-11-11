import { derived, writable } from "svelte/store";
import { appState } from "./state";

/** The FC-200 pages (src/pages.py), in page order. */
export const PAGES = ["scenes", "loops", "favorites"] as const;

/** A store remembered per device (localStorage; private mode just forgets). */
export function remembered<T>(key: string, fallback: T) {
  let initial = fallback;
  try {
    const raw = localStorage.getItem(key);
    if (raw !== null) initial = JSON.parse(raw);
  } catch {
    // unavailable or unreadable: start from the fallback
  }
  const store = writable<T>(initial);
  store.subscribe((value) => {
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch {
      // not remembered
    }
  });
  return store;
}

/** Follow the FC-200's page, or pick pages here. */
export const follow = remembered("fc200.follow", true);

/** The page chosen here while not following; survives reloads and reconnects. */
export const localPage = remembered("fc200.page", 0);

export const shownPage = derived([follow, localPage, appState], ([$follow, $local, $s]) =>
  $follow ? ($s.page ?? 0) : $local,
);
