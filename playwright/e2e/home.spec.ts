import { test, expect } from '@playwright/test';

test('Home page loads and shows heading', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('h1')).toHaveText(/Welcome to BallotBuilder/);
});
