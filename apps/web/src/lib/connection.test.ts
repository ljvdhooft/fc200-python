import { afterEach, beforeEach, expect, test, vi } from "vitest";
import { Connection, type Retry } from "./connection";

/** A socket that fails or opens when the test says so. */
class FakeSocket {
  static last: FakeSocket;
  readyState = 0;
  onopen: (() => void) | null = null;
  onclose: (() => void) | null = null;
  onmessage: ((ev: { data: string }) => void) | null = null;
  onerror: (() => void) | null = null;
  constructor() {
    FakeSocket.last = this;
  }
  open() {
    this.readyState = 1;
    this.onopen?.();
  }
  close() {
    this.readyState = 3;
    this.onclose?.();
  }
  send() {}
}

beforeEach(() => vi.useFakeTimers());
afterEach(() => vi.useRealTimers());

test("reports each reconnect attempt and clears it once connected", () => {
  const conn = new Connection({ url: "ws://x", minDelay: 100, maxDelay: 1000, createSocket: () => new FakeSocket() as unknown as WebSocket });
  const seen: (Retry | null)[] = [];
  conn.onRetry((r) => seen.push(r));
  conn.start();

  FakeSocket.last.close(); // hub unreachable
  expect(seen.at(-1)).toMatchObject({ attempt: 1, at: Date.now() + 100 });
  vi.advanceTimersByTime(100);
  FakeSocket.last.close();
  expect(seen.at(-1)).toMatchObject({ attempt: 2, at: Date.now() + 200 });

  vi.advanceTimersByTime(200);
  FakeSocket.last.open();
  expect(seen.at(-1)).toBeNull();
  conn.stop();
});
