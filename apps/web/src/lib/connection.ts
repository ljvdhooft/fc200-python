export type LinkStatus = "connecting" | "open" | "closed";

export interface RequestError {
  code: string;
  message: string;
}

export class ProtocolError extends Error {
  constructor(public code: string, message: string) {
    super(message);
  }
}

interface Pending {
  resolve: (v: unknown) => void;
  reject: (e: Error) => void;
  timer: ReturnType<typeof setTimeout>;
}

export interface ConnectionOptions {
  url?: string;
  /** Backoff: first delay, doubling up to maxDelay (ms). */
  minDelay?: number;
  maxDelay?: number;
  requestTimeout?: number;
  /** Injectable for tests. */
  createSocket?: (url: string) => WebSocket;
}

type EventHandler = (data: unknown) => void;

export function defaultUrl(): string {
  const proto = location.protocol === "https:" ? "wss:" : "ws:";
  return `${proto}//${location.host}/ws`;
}

export class Connection {
  private ws: WebSocket | null = null;
  private nextId = 1;
  private attempt = 0;
  private retry: ReturnType<typeof setTimeout> | null = null;
  private stopped = true;
  private pending = new Map<number, Pending>();
  private handlers = new Map<string, Set<EventHandler>>();
  private statusHandlers = new Set<(s: LinkStatus) => void>();
  private opts: Required<Omit<ConnectionOptions, "url">> & { url: string };
  status: LinkStatus = "closed";

  constructor(opts: ConnectionOptions = {}) {
    this.opts = {
      url: opts.url ?? defaultUrl(),
      minDelay: opts.minDelay ?? 250,
      maxDelay: opts.maxDelay ?? 5000,
      requestTimeout: opts.requestTimeout ?? 5000,
      createSocket: opts.createSocket ?? ((u) => new WebSocket(u)),
    };
  }

  start(): void {
    if (!this.stopped) return;
    this.stopped = false;
    this.open();
  }

  stop(): void {
    this.stopped = true;
    if (this.retry) clearTimeout(this.retry);
    this.retry = null;
    this.ws?.close();
  }

  /** Subscribe to an event name; returns an unsubscribe function. */
  on(event: string, handler: EventHandler): () => void {
    let set = this.handlers.get(event);
    if (!set) this.handlers.set(event, (set = new Set()));
    set.add(handler);
    return () => set.delete(handler);
  }

  onStatus(handler: (s: LinkStatus) => void): () => void {
    this.statusHandlers.add(handler);
    return () => this.statusHandlers.delete(handler);
  }

  request<T = unknown>(method: string, params?: object, timeout = this.opts.requestTimeout): Promise<T> {
    const ws = this.ws;
    if (!ws || ws.readyState !== WebSocket.OPEN) {
      return Promise.reject(new ProtocolError("not_connected", "not connected to the hub"));
    }
    const id = this.nextId++;
    return new Promise<T>((resolve, reject) => {
      const timer = setTimeout(() => {
        this.pending.delete(id);
        reject(new ProtocolError("timeout", `${method} timed out`));
      }, timeout);
      this.pending.set(id, { resolve: resolve as (v: unknown) => void, reject, timer });
      ws.send(JSON.stringify(params === undefined ? { id, method } : { id, method, params }));
    });
  }

  /** Fire and forget (still gets a response from the hub, which is ignored). */
  send(method: string, params?: object): void {
    this.request(method, params).catch(() => {});
  }

  private setStatus(s: LinkStatus): void {
    this.status = s;
    this.statusHandlers.forEach((h) => h(s));
  }

  private open(): void {
    this.setStatus("connecting");
    const ws = this.opts.createSocket(this.opts.url);
    this.ws = ws;
    ws.onopen = () => {
      this.attempt = 0;
      this.setStatus("open");
    };
    ws.onmessage = (ev) => this.handle(String(ev.data));
    ws.onclose = () => {
      if (this.ws !== ws) return;
      this.ws = null;
      this.failPending();
      this.setStatus("closed");
      if (!this.stopped) this.scheduleRetry();
    };
    ws.onerror = () => ws.close();
  }

  private scheduleRetry(): void {
    const delay = Math.min(this.opts.minDelay * 2 ** this.attempt, this.opts.maxDelay);
    this.attempt++;
    this.retry = setTimeout(() => {
      this.retry = null;
      if (!this.stopped) this.open();
    }, delay);
  }

  private failPending(): void {
    for (const p of this.pending.values()) {
      clearTimeout(p.timer);
      p.reject(new ProtocolError("disconnected", "connection lost"));
    }
    this.pending.clear();
  }

  private handle(text: string): void {
    let msg: Record<string, unknown>;
    try {
      msg = JSON.parse(text);
    } catch {
      console.warn("bad JSON from hub", text);
      return;
    }
    if (typeof msg.event === "string") {
      this.handlers.get(msg.event)?.forEach((h) => h(msg.data));
    } else if (typeof msg.id === "number") {
      const p = this.pending.get(msg.id);
      if (!p) return;
      this.pending.delete(msg.id);
      clearTimeout(p.timer);
      const err = msg.error as RequestError | undefined;
      if (err) p.reject(new ProtocolError(err.code, err.message));
      else p.resolve(msg.result);
    }
  }
}
