import { defineConfig } from "vite"

import RubyPlugin from "vite-plugin-ruby"
import svgr from "vite-plugin-svgr"
import FullReload from "vite-plugin-full-reload"

export default defineConfig({
  plugins: [
    RubyPlugin(),
    svgr({
      exportAsDefault: true,
    }),
    FullReload([
      "config/routes.rb",
      "app/views/**/*",
      "app/controllers/**/*",
      "app/models/**/*",
    ]),
  ],
})
