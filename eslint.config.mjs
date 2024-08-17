import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default [
  {
    ignores: [
      "tailwind.config.js",
      "app/assets/builds/**/*",
      "coverage/**/*",
      "vendor/**/*",
    ],
  },
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
];
