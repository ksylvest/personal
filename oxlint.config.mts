import { defineConfig } from "oxlint";

export default defineConfig({
  plugins: ["typescript", "unicorn", "oxc"],
  ignorePatterns: ["config/**/*", "public/**/*", "vendor/**/*"],
});
