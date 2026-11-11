import { mount } from "svelte";
import "./lib/tokens.css";
import "./lib/base.css";
import App from "./App.svelte";
import { Connection } from "./lib/connection";
import { bind } from "./lib/state";
import { keepAwake } from "./lib/wakelock";

export const connection = new Connection();
bind(connection);
connection.start();
keepAwake();

if ("serviceWorker" in navigator && import.meta.env.PROD) {
  navigator.serviceWorker.register("/sw.js").catch(() => {});
}

export default mount(App, { target: document.getElementById("app")! });
