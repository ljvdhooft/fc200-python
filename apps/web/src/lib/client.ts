import { Connection } from "./connection";

/** The one connection to the hub, shared by main.ts and the views. */
export const connection = new Connection();
