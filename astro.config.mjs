import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://www.steamtools.app',
  build: {
    format: 'directory',
    inlineStylesheets: 'always',
  },
});
