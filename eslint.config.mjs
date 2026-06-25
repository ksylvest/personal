// @ts-check

import eslint from "@eslint/js";
import { defineConfig } from 'eslint/config';
import tseslint from "typescript-eslint";

export default defineConfig(
  {
    ignores: [
      "tailwind.config.js",
      "app/assets/builds/**/*",
      "coverage/**/*",
      "vendor/**/*",
    ],
    extends: [
      eslint.configs.recommended,
      tseslint.configs.recommended,
    ]
  },
);
