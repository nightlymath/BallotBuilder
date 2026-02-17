import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: 'playwright/e2e',
  timeout: 30_000,
  retries: process.env.CI ? 2 : 0,
  reporter: [['dot'], ['html', { outputFolder: 'playwright-report' }]],
  projects: [
    {
      name: 'edge',
      use: { channel: 'msedge', headless: true },
    },
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
});
