import { defineConfig } from "vite"

import RubyPlugin from "vite-plugin-ruby"
import svgr from "vite-plugin-svgr"

export default defineConfig({
  additionalEntrypoints: ["@/components/*"],
  plugins: [
    RubyPlugin(),
    svgr({
      exportAsDefault: true,
    }),
  ],
  host: "0.0.0.0",
  port: 3036,
  hmr: {
    host: "localhost",
    port: 3036,
  },
})
