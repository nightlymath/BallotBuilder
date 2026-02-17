# research.md — 001-add-nextjs-app

## Purpose
Resolve implementation choices and record rationale for the Next.js TypeScript scaffold, testing stack, and Playwright + MS Edge configuration.

### Research items & findings

1) Playwright default browser = MS Edge
- Decision: Use Playwright Test Runner with a dedicated `edge` project using `use: { channel: 'msedge' }`.
- Rationale: Matches stakeholder requirement; Edge (Chromium) is supported by Playwright via `channel` and runs in CI with the Chromium engine.
- Alternatives considered: Chromium (default) or WebKit. Rejected because stakeholder explicitly requested Edge.
- Action: Add Playwright project config and GitHub Actions snippet running `npx playwright install --with-deps`.

2) Jest + React Testing Library with Next.js (TypeScript)
- Decision: Jest + @testing-library/react in TypeScript using `ts-jest` or `babel-jest` with `@testing-library/react` typings.
- Rationale: Widely used, easy TDD feedback loop, integrates with Next.js testing best practices.
- Alternatives: Vitest (faster), but Jest chosen for broad familiarity and ecosystem maturity.
- Action: Add `jest.config.ts` and example `__tests__/Home.test.tsx`.

3) CI Playwright best practices
- Decision: Use GitHub Actions example that installs Playwright browsers (`npx playwright install --with-deps`) and runs `npx playwright test --project=edge --reporter=dot` in headless mode.
- Rationale: Ensures required browser is available in CI and produces artifacts for failure inspection.
- Alternatives: Self-hosted runners with preinstalled browsers — out of scope for initial scaffold.
- Action: Provide `ci/playwright.yml` snippet in `quickstart.md`.

## Consolidated decisions
- Language: TypeScript (selected by stakeholder).
- Next.js + Jest + RTL for unit testing; Playwright Test Runner for E2E (edge project configured).
- Node.js 20 LTS runtime for local dev and CI.

## Implementation notes (short)
- Playwright `playwright.config.ts` will include:
  - `projects: [{ name: 'edge', use: { channel: 'msedge' } }]`
  - `retries: process.env.CI ? 2 : 0` and `reporter: [['dot'], ['html', { outputFolder: 'playwright-report' }]]`
- Jest config will include support for TypeScript and React Testing Library; sample test in `src/__tests__/Home.test.tsx`.

## Alternatives / Risks
- Using Vitest instead of Jest reduces runtime but requires migration guidance — deferred.
- Playwright relies on Playwright-provided browser binaries in CI; ensure `npx playwright install --with-deps` runs in CI.

## Outcome
All outstanding ambiguities from the spec have been resolved; research supports proceeding to Phase 1 and implementation.
