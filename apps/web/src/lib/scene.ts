import type { Scene } from "./state";

export const hex = (color: number) => `#${color.toString(16).padStart(6, "0")}`;
// Live shows scene numbers from 1
export const number = (scene: Scene) => scene.index + 1;
