import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  additionalEntrypoints: [
    "@/components/*"
  ],
  plugins: [
    RubyPlugin(),
  ],
  host: "0.0.0.0",
  port: 3036,
  hmr: {
    host: "localhost",
    port: 3036
  }
})
