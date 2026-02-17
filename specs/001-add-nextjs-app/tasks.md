---
description: "Tasks for feature: Initialize Next.js app — BallotBuilder"
---

# Tasks: Initialize Next.js app — BallotBuilder

**Input**: Design documents from `specs/001-add-nextjs-app/` (plan.md, spec.md, research.md, quickstart.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic developer tooling (TypeScript, linting, test frameworks)

- [ ] T001 Create Next.js (TypeScript) project skeleton and base files in `package.json`, `tsconfig.json`, `next.config.mjs`, `src/app/page.tsx`
- [ ] T002 Initialize `package.json` scripts (`dev`, `build`, `start`, `test`, `test:watch`, `e2e:headless`, `e2e:edge`) in `package.json`
- [ ] T003 [P] Configure ESLint and Prettier (`.eslintrc.cjs`, `.prettierrc`) to match repo standards — maps to NFR-001 (code quality)
- [ ] T004 [P] Add TypeScript config and path aliases in `tsconfig.json`
- [ ] T005 [P] Configure unit test framework (Jest + React Testing Library): add `jest.config.ts`, `src/setupTests.ts`, and example test folder `src/__tests__/` 
- [ ] T006 [P] Configure Playwright Test Runner and BDD test folder structure: add `playwright.config.ts`, `playwright/`, and `playwright/e2e/` directory
- [ ] T031 Create PR template and PR-checklist to enforce constitution PR metadata (spec link, tests, risk assessment) — maps to constitution governance

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infra that MUST be complete before user stories are implemented (TDD/BDD gates, CI Playwright setup, accessibility baseline)

- [ ] T007 Setup Playwright project for MS Edge in `playwright.config.ts` (`projects: [{ name: 'edge', use: { channel: 'msedge' } }]`)
- [ ] T008 [P] Create failing test skeletons for TDD: `src/__tests__/Home.test.tsx` (Jest) and `playwright/e2e/home.spec.ts` (Playwright)
- [ ] T009 [P] Create BDD acceptance skeleton file `features/home.feature` (BDD scenario for "Home page loads")
- [ ] T010 Add CI workflow to install Playwright browsers and run headless E2E: `.github/workflows/e2e.yml`
- [ ] T011 Implement accessibility baseline & remediation plan and add `docs/accessibility.md` (WCAG 2.1 AA target documented)
- [ ] T012 [P] Add environment / config example file `.env.example` and document port/runtime expectations in `README.md` or `specs/001-add-nextjs-app/quickstart.md`

**Checkpoint**: Foundation ready — Jest + Playwright configured, BDD skeletons in place, CI snippet present. ALL Phase 2 tasks MUST be complete before starting user story implementation.

---

## Phase 3: User Story 1 - Scaffold & smoke E2E (Priority: P1) 🎯 MVP

**Goal**: Deliver a runnable Next.js scaffold and a Playwright smoke test that validates the home page loads.

**Independent Test**: `npm run dev` → `npm run e2e:headless` (Playwright smoke test) → passes

### Tests (TDD / BDD first)
- [ ] T013 [P] [US1] Add BDD acceptance scenario for Home page in `features/home.feature` (must fail before implementation)
- [ ] T014 [P] [US1] Add Playwright smoke test that implements BDD steps in `playwright/e2e/home.spec.ts` (must fail first)

### Implementation
- [ ] T015 [US1] Implement `Home` component in `src/components/Home.tsx` and wire into `src/app/page.tsx` (make Playwright smoke test pass)
- [ ] T016 [US1] Add minimal styling/content and ensure heading text used in BDD (`src/components/Home.tsx`, `src/styles/`)
- [ ] T017 [US1] Update `specs/001-add-nextjs-app/quickstart.md` with exact run steps for the smoke E2E

**Checkpoint**: US1 is complete when Playwright smoke test passes independently and `npm run dev` serves HTTP 200 at `/`.

---

## Phase 4: User Story 2 - Unit & component tests (Priority: P1)

**Goal**: Configure Jest + React Testing Library and deliver example unit/component tests following TDD.

**Independent Test**: `npm test` → passes example `Home` component test

### Tests (TDD)
- [ ] T018 [P] [US2] Write failing Jest + RTL test for `Home` component in `src/__tests__/Home.test.tsx` (TDD)

### Implementation
- [ ] T019 [US2] Implement `Home` unit/component code (if missing) and ensure `src/__tests__/Home.test.tsx` passes
- [ ] T020 [US2] Add `test:watch` script and document local test workflow in `README.md`
- [ ] T021 [US2] Ensure unit tests run in CI (`.github/workflows/e2e.yml` or CI pipeline) and add badges/documentation in `README.md`

**Checkpoint**: US2 complete when `npm test` exits 0 and one or more unit tests validate `Home` component behaviour.

---

## Phase 5: User Story 3 - Playwright E2E commands & CI (Priority: P2)

**Goal**: Provide developer-friendly E2E commands (headed + headless) and wire Playwright into CI using MS Edge as default.

**Independent Test**: `npm run e2e:headless` (CI) and `npm run e2e:edge` (local headed) both pass

- [ ] T022 [US3] Add `e2e:headless` and `e2e:edge` scripts to `package.json` (if not present)
- [ ] T023 [US3] Add or update GitHub Actions workflow to run Playwright headless with Edge and save `playwright-report` artifacts (`.github/workflows/e2e.yml`)
- [ ] T024 [US3] Configure Playwright CI retries and artifact collection in `playwright.config.ts`
- [ ] T025 [US3] Add developer docs for running headed Edge locally (`README.md` / `specs/001-add-nextjs-app/quickstart.md`)

**Checkpoint**: US3 complete when CI runs `npm run e2e:headless` successfully and `npm run e2e:edge` runs locally on MS Edge.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements and cross-cutting tasks that affect multiple stories

- [ ] T026 [P] Add automated accessibility checks (axe-core) for `Home` page in unit or E2E tests (`tests/a11y/`)
- [ ] T027 [P] Add lint/prettier pre-commit hook and CI lint step (`.husky/pre-commit`, `package.json`) — maps to NFR-001 (code quality)
- [ ] T028 [P] Documentation updates: `README.md`, `specs/001-add-nextjs-app/quickstart.md`, `docs/`
- [ ] T029 [P] Add Playwright HTML report publishing step to CI and include failure screenshots (`.github/workflows/e2e.yml`)
- [ ] T030 [P] Run quickstart validation and mark `specs/001-add-nextjs-app/quickstart.md` verified

---

## Dependencies & Execution Order

- Phase 1 (Setup): no dependencies — start here.
- Phase 2 (Foundational): depends on Phase 1 completion — **BLOCKS** all user stories.
- Phase 3 / Phase 4 (User Stories P1): depend on Phase 2; US1 and US2 are independent of each other and can run in parallel after foundation is ready.
- Phase 5 (US3): depends on Phase 2 and on US1 (E2E smoke test assumes Home page implemented).
- Polish: depends on completion of user stories.

### User Story Dependencies (summary)
- US1 (P1): Foundation → US1
- US2 (P1): Foundation → US2
- US3 (P2): Foundation + US1 → US3

---

## Parallel execution examples
- Developer A: Implement `Home` component (`src/components/Home.tsx`) (US1)
- Developer B: Implement Jest test and test:watch (`src/__tests__/Home.test.tsx`) (US2)
- Developer C: Configure Playwright `playwright.config.ts` and CI (`.github/workflows/e2e.yml`) (Foundational)

Each of the above can progress independently once Phase 2 is complete.

---

## Implementation Strategy

1. MVP first: complete Phase 1 + Phase 2 → then implement US1 (MVP). Validate by running Playwright smoke test and unit tests.
2. Incremental delivery: add US2 next (unit tests/TDD), then US3 (CI + headed runs). Keep tasks small and test-first.
3. Enforce TDD: always write/commit failing tests (unit/contract/BDD/Playwright) before implementing code.

---

## Files & locations changed by tasks (high level)
- `package.json`, `tsconfig.json`, `next.config.mjs`, `src/app/page.tsx`, `src/components/Home.tsx`
- `jest.config.ts`, `src/setupTests.ts`, `src/__tests__/Home.test.tsx`
- `playwright.config.ts`, `playwright/e2e/home.spec.ts`, `features/home.feature`
- `.github/workflows/e2e.yml`, `docs/accessibility.md`, `specs/001-add-nextjs-app/quickstart.md`

---

## Acceptance / Test criteria per story (short)
- US1: Playwright smoke test (`playwright/e2e/home.spec.ts`) passes and `GET /` returns HTTP 200.
- US2: `npm test` passes and unit test for `Home` validates expected content.
- US3: `npm run e2e:headless` passes in CI using MS Edge; `npm run e2e:edge` runs locally.

---

## Implementation notes
- Tests MUST be committed failing first (TDD). BDD scenarios should be human-readable and link to the Playwright test.
- Use Playwright `channel: 'msedge'` to target Edge; ensure CI `npx playwright install --with-deps` is included.
- Keep Home component minimal — text used in BDD should be stable and accessible.

---

**Generated tasks file**: `specs/001-add-nextjs-app/tasks.md`
