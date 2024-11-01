/** @type {import('tailwindcss').Config} */

import forms from "@tailwindcss/forms";
import typography from "@tailwindcss/typography";

export default {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/packs/**/*.js",
    "./app/packs/**/*.ts",
  ],
  plugins: [forms, typography],
  safelist: ["highlight"],
};
