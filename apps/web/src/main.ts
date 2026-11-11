import { mount } from "svelte";
import "./lib/tokens.css";
import "./lib/base.css";
import App from "./App.svelte";
import { connection } from "./lib/client";
import { bind } from "./lib/state";
import { keepAwake } from "./lib/wakelock";
import { trackIsland } from "./lib/island";
import { trackTouch } from "./lib/touch";

bind(connection);
connection.start();
keepAwake();
trackIsland();
trackTouch();
// iOS Safari only applies :active (the pressed look of every button) once the
// page listens for touches
document.addEventListener("touchstart", () => {}, { passive: true });

if ("serviceWorker" in navigator && import.meta.env.PROD) {
  navigator.serviceWorker.register("/sw.js").catch(() => {});
}

export default mount(App, { target: document.getElementById("app")! });
