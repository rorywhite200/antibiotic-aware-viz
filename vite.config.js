import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vitejs.dev/config/
export default defineConfig({
  base: '/antibiotic-aware-viz/',
  plugins: [svelte()],
  build: {
    outDir: './docs', // relative to index.html
     emptyOutDir: true, 
  }
})
