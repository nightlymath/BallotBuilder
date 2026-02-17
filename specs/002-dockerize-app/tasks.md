---
description: 'Implementation tasks for 002-dockerize-app — containerize development & CI'
---

# Tasks: Containerize development & CI (002-dockerize-app)

**Input**: Design docs in `specs/002-dockerize-app/` (spec.md, plan.md, research.md, quickstart.md)

## Summary

Create reproducible developer containers (dev-in-container), add CI "build + validate" jobs that build the same image and run the full test suite and security/accessibility scans. CI will validate images only (no publishing/promotion in this scope).

---

## Phase 1: Setup (Shared infrastructure)

Purpose: add developer-facing container files, helper scripts and basic documentation so a developer can run and debug the app entirely inside a container.

- [x] T001 [P] Create multi-stage `Dockerfile` that builds the app and produces a validation image (`/Dockerfile`)
- [x] T002 [P] Create a development-friendly Dockerfile for bind-mounted hot-reload (`/Dockerfile.dev`)
- [x] T003 [P] Add repository `.dockerignore` to keep build context small (`/.dockerignore`)
- [x] T004 [P] Add VS Code devcontainer configuration (`.devcontainer/devcontainer.json`)
- [x] T005 [P] Add cross-platform developer start script `scripts/dev-in-container.sh` (Linux/macOS) - usage: start dev container and mount workspace (`/scripts/dev-in-container.sh`)
- [x] T006 [P] Add cross-platform developer start script `scripts/dev-in-container.ps1` (Windows PowerShell) (`/scripts/dev-in-container.ps1`)
- [x] T007 [P] Add local validation script `scripts/validate-container.sh` that builds `Dockerfile.ci` (or `Dockerfile`) and runs tests + trivy (`/scripts/validate-container.sh`)
- [ ] T008 [P] Add local validation script `scripts/validate-container.ps1` for Windows PowerShell (`/scripts/validate-container.ps1`)
- [ ] T009 [P] Add quick-reference dev-in-container section to `README.md` (link to `specs/002-dockerize-app/quickstart.md`) (`/README.md`)

---

## Phase 2: Foundational (Blocking prerequisites)

Purpose: CI jobs, security scans and failing test skeletons that MUST exist before story work begins.

**CRITICAL**: Complete these tasks before implementing user stories.

- [x] T010 [P] Add `validate:container` npm script to `package.json` (runs `scripts/validate-container.*`) (`/package.json`)
- [x] T011 Create GitHub Actions workflow `ci-container-validate` that builds the validation image and runs tests + scans (`/.github/workflows/ci-container-validate.yml`)
- [x] T012 [P] Add Trivy wrapper script for CI `scripts/ci/scan-image.sh` (`/scripts/ci/scan-image.sh`)
- [x] T013 [P] Add secrets-detection wrapper for CI `scripts/ci/secrets-scan.sh` (invokes `trufflehog` or equivalent) (`/scripts/ci/secrets-scan.sh`)
- [x] T014 [P] Add CI helper script `scripts/ci/run-in-image.sh` (run `npm test`/`npm run test:a11y` inside the built image) (`/scripts/ci/run-in-image.sh`)
- [x] T015 [P] Create failing test skeletons for P1 (TDD enforcement):
  - `src/__tests__/Home.a11y.test.tsx` (jest-axe skeleton)
  - `playwright/e2e/devcontainer.spec.ts` (Playwright acceptance skeleton)

**Constitution Checkpoint**: After Phase 2 the repo must show:

- CI job defined for build+validate (`T011`) and artifacts archived
- Security-scan step (`T012`) and secrets-scan step (`T013`)
- Accessibility test skeleton(s) present (`T015`)

---

## Phase 3: User Story 1 — Developer onboarding & daily development (Priority: P1) 🎯 MVP

Goal: Developer can run, hot-reload, test and debug the app entirely inside the container.

Independent test: Fresh clone, follow `README.md` → `scripts/dev-in-container.*` → open http://localhost:3000 and attach debugger from VS Code.

### Tests (TDD / acceptance)

- [x] T016 [P] [US1] Implement `src/__tests__/Home.a11y.test.tsx` using `jest-axe` (unit a11y check for `Home` component)
- [x] T017 [US1] Add Playwright acceptance test `playwright/e2e/devcontainer.spec.ts` that verifies the app loads at `/` when started in container

### Implementation

- [x] T018 [US1] Ensure `Dockerfile.dev` supports bind-mount hot-reload and exposes port `3000` (`/Dockerfile.dev`)
- [x] T019 [US1] Finalize `.devcontainer/devcontainer.json` with forwarded ports and workspace mount (`.devcontainer/devcontainer.json`)
- [x] T020 [P] [US1] Populate `scripts/dev-in-container.*` with documented start/debug commands and editor attach guidance (`/scripts/dev-in-container.sh`, `/scripts/dev-in-container.ps1`)
- [x] T021 [US1] Update `README.md` with step-by-step dev-in-container + debugger attach instructions and troubleshooting (`/README.md`)

Checkpoint: US1 is independently testable when `T016` and `T017` pass and the devcontainer starts and serves the app.

---

## Phase 4: User Story 2 — CI build & validation (Priority: P2)

Goal: Every PR triggers a CI job that builds the same image developers use and runs the full automated test-suite and security/accessibility scans.

Independent test: Open a PR and confirm the `ci-container-validate` workflow runs: build image → run tests → run a11y checks → run Trivy/secrets scan → artifacts + metadata appear and job blocks the PR on failures.

### Tests

- [ ] T022 [P] [US2] Add CI workflow unit/integration/a11y test runner steps in `.github/workflows/ci-container-validate.yml`
- [ ] T023 [US2] Add workflow steps to upload test results and Trivy/scan reports as artifacts (`/.github/workflows/ci-container-validate.yml`)

### Implementation

- [ ] T024 [US2] Implement image build step (Buildx) and run validation inside the image (`/.github/workflows/ci-container-validate.yml`)
- [ ] T025 [P] [US2] Add Trivy scan invocation in CI and fail the job on `CRITICAL` findings (`/.github/workflows/ci-container-validate.yml` + `/scripts/ci/scan-image.sh`)
- [ ] T026 [P] [US2] Add secrets-detection step in CI that runs `scripts/ci/secrets-scan.sh` and fails on findings (`/.github/workflows/ci-container-validate.yml`)
- [ ] T027 [US2] Ensure CI attaches build metadata (commit SHA and feature number) to workflow artifacts and logs (`/.github/workflows/ci-container-validate.yml`)

Checkpoint: US2 is complete when PRs are blocked on failing build/tests/scans and artifacts are available in the CI job.

---

## Phase 5: User Story 3 — Local CI parity & reproduction (Priority: P3)

Goal: Developers can reproduce CI validation locally using provided scripts; publishing is out-of-scope for this feature.

Independent test: Run `npm run validate:container` or `scripts/validate-container.*` locally and observe same pass/fail outcome as CI for the same commit.

### Tests

- [ ] T028 [P] [US3] Add/verify local validation script `scripts/validate-container.*` reproduces CI steps and returns non-zero on failures (`/scripts/validate-container.sh`, `/scripts/validate-container.ps1`)

### Implementation

- [ ] T029 [P] [US3] Add `validate:container` npm script to `package.json` that delegates to `scripts/validate-container.*` (`/package.json`)
- [ ] T030 [US3] Document local reproduction steps in `specs/002-dockerize-app/quickstart.md` and `README.md` (`/specs/002-dockerize-app/quickstart.md`, `/README.md`)

Checkpoint: US3 is complete when `npm run validate:container` reproduces CI results locally for the same commit.

---

## Final Phase: Polish & Cross-cutting Concerns

- [ ] T031 [P] Add or update docs in `docs/` describing developer container, CI validation and troubleshooting (`/docs/dev-in-container.md` or `/README.md`)
- [ ] T032 [P] Add automated quickstart verification task (script that runs a minimal smoke test in CI or locally) (`/scripts/ci/quickstart-smoke.sh`)
- [ ] T033 [P] Run `specs/002-dockerize-app/quickstart.md` validation and fix any broken steps (`/specs/002-dockerize-app/quickstart.md`)
- [ ] T034 [P] Add a test matrix or caching to CI workflow to improve median runtime if needed (`/.github/workflows/ci-container-validate.yml`)

---

## Dependencies & Execution Order

1. Phase 1 (Setup) tasks (T001–T009) can run in parallel and must finish first.
2. Phase 2 (Foundational) tasks (T010–T015) block user story implementation — complete before Phase 3.
3. Phase 3+ (User stories) proceed in priority order (US1 → US2 → US3) but multiple stories can be worked on in parallel after Phase 2 completes.
4. Final Phase (Polish) runs after stories are feature-complete.

### User story dependency summary

- US1 (P1): Depends on Phase 1 + Phase 2
- US2 (P2): Depends on Phase 1 + Phase 2; should be implemented after US1 for MVP but can run in parallel
- US3 (P3): Depends on Phase 1 + Phase 2; low priority

---

## Parallel execution examples (per story)

- US1 parallel: `T016` (a11y unit test) and `T017` (Playwright smoke) run concurrently.
- US2 parallel: `T025` (Trivy) and `T026` (secrets-scan) run concurrently inside CI.
- Setup parallel: create `Dockerfile`, `.devcontainer`, and helper scripts concurrently (T001, T004, T005) — all independent files.

---

## Implementation strategy (MVP first) 🎯

1. Complete Phase 1 + Phase 2 (T001–T015) so foundation and CI gates exist.
2. Implement US1 (T016–T021) as the MVP — developer can run & debug in-container and run accessibility/unit tests.
3. Implement US2 (T022–T027) — CI image build + validation and security gates.
4. Implement US3 (T028–T030) — local parity and docs.
5. Polish (T031–T034) and measure CI runtime; optimize caching as needed.

---

## Acceptance / independent test criteria (one-liners)

- US1: Developer follows `README.md` → `scripts/dev-in-container.*` → app loads at port 3000 and `src/__tests__/Home.a11y.test.tsx` passes inside container.
- US2: PR triggers `ci-container-validate` that builds image, runs `npm test` + `npm run test:a11y`, runs Trivy/secrets-scan and blocks on failures.
- US3: `npm run validate:container` reproduces CI results locally for the same commit.

---

## Files to be added/modified (quick reference)

- Dockerfiles: `Dockerfile`, `Dockerfile.dev`, (optional `Dockerfile.ci`)
- Dev container: `.devcontainer/devcontainer.json`
- Scripts: `scripts/dev-in-container.*`, `scripts/validate-container.*`, `scripts/ci/*`
- CI workflow: `.github/workflows/ci-container-validate.yml`
- Tests: `src/__tests__/Home.a11y.test.tsx`, `playwright/e2e/devcontainer.spec.ts`
- Docs: `README.md`, `specs/002-dockerize-app/quickstart.md`, `docs/*`

---

**MVP recommendation**: Deliver Phase 1 + Phase 2 + User Story 1 (complete T001–T021). This provides immediate developer value (dev-in-container) and a repeatable local validation loop.

**Estimated task count**: 34 (listed above)

**Format validation**: All tasks follow the required checklist format with Task IDs and explicit file paths.
