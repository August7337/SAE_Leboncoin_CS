import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  test: {
    // This allows you to use 'describe', 'it', 'expect' without importing them in every file
    globals: true, 
    environment: 'jsdom', // Simulates a browser environment
  },
  resolve: {
    alias: {
      // Makes sure '@' points to your 'src' folder
      '@': path.resolve(__dirname, './src'),
    },
  },
})