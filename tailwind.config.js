/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/packs/**/*.js",
    "./app/packs/**/*.ts",
  ],
  plugins: [require("@tailwindcss/forms")],
  safelist: ["highlight"],
};
