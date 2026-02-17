# quickstart.md — 001-add-nextjs-app (BallotBuilder)

## Quickstart (developer)

1. Install dependencies

```bash
npm install
```

2. Start dev server

```bash
npm run dev
# open http://localhost:3000
```

3. Run unit tests (Jest + React Testing Library)

```bash
npm test
```

4. Run Playwright E2E

Headless (CI):
```bash
npm run e2e:headless
```

Headed (MS Edge):
```bash
npm run e2e:edge
```

## CI example (GitHub Actions snippet)

```yaml
- name: Install Playwright browsers
  run: npx playwright install --with-deps

- name: Run Playwright E2E (headless, Edge)
  run: npm run e2e:headless
  env:
    CI: true
```

## Troubleshooting
- If Playwright cannot find MS Edge in CI, ensure `npx playwright install --with-deps` has run and the runner supports Chromium.
- For flaky tests, Playwright `retries` is set higher in CI and `playwright-report` artifacts are produced for debugging.
