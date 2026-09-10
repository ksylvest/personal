import type { KnipConfig } from "knip";

const config: KnipConfig = {
  entry: ["app/packs/entrypoints/*.*"],
  project: ["app/packs/**/*"],
};

export default config;
