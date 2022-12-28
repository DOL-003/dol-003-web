import { defineConfig } from "vite"

import RubyPlugin from "vite-plugin-ruby"
import svgr from "vite-plugin-svgr"

export default defineConfig({
  plugins: [
    RubyPlugin(),
    svgr({
      exportAsDefault: true,
    }),
  ],
})
