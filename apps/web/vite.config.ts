import { defineConfig } from "vitest/config";
import { svelte } from "@sveltejs/vite-plugin-svelte";

export default defineConfig({
  plugins: [svelte()],
  server: {
    host: true, // reachable from the iPad/iPhone on the LAN
    allowedHosts: ["fc200.local"], // the hub's mDNS name
    proxy: { "/ws": { target: "ws://127.0.0.1:20031", ws: true } },
  },
  build: { outDir: "dist", emptyOutDir: true },
  test: { include: ["src/**/*.test.ts"], environment: "node" },
});
