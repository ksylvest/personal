/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "./app/views/**/*.{erb,haml,html,slim}",
    "./app/helpers/**/*.rb",
    "./app/packs/**/*.css",
    "./app/packs/**/*.js",
    "./app/packs/**/*.ts",
  ],
  plugins: [require("@tailwindcss/forms")],
  safelist: ["highlight"],
};
