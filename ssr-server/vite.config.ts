import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist/client',
    ssr: 'src/entry-server.tsx', // This is where the SSR entrypoint is defined
    rollupOptions: {
      input: 'index.html'
    }
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src')
    }
  },
  ssr: {
    external: ['react-router-dom']
  }
})

