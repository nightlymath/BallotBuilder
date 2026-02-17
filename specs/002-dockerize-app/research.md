# research.md — Containerize development & CI

## Purpose

Resolve open decisions and capture engineering research required to implement reproducible developer containers and CI validation for container images.

## Decisions & Rationale

- Decision: CI will _not publish_ images; CI images are _validation-only_.

  - Rationale: reduces scope and security/ops burden for this change; publishing and promotion require policy, registry access, hardening, and release governance that are out of scope for this task.
  - Alternatives considered: publish-to-registry (requires secrets + policy) — rejected for scope/ops reasons.

- Decision: Use a multi-stage Dockerfile (Node 18-slim base) and a `devcontainer.json` for VS Code dev-in-container experience.

  - Rationale: Node 18 is compatible with Next.js 13; `-slim` provides predictable binaries while avoiding alpine-specific issues with native deps. Multi-stage enables small CI validation images while keeping dev ergonomics.
  - Alternatives: `node:18-alpine` (smaller image) — rejected due to native build compatibility and reproducibility on Windows runners.

- Decision: CI build → run tests inside the built image (validation job). Use Docker Buildx + GitHub Actions runner. Use Trivy for vulnerability scanning and `jest` + `playwright`/`jest-axe` for tests and accessibility checks.
  - Rationale: Running the test-suite inside the same image used in CI gives high parity between local dev and CI validation. Trivy is fast and commonly used in GH Actions.
  - Alternatives: Kaniko or remote builder; not necessary for current CI runners.

## Research tasks (Phase 0)

1. Dev-experience: confirm hot-reload works with bind-mount in Next.js inside container and document `devcontainer.json` recommended settings (ports, workspaceMount, forwardedPorts).
2. Dockerfile: author a multi-stage Dockerfile with a `dev` stage (bind-mount friendly) and `ci/production` stage (COPY + build). Verify build caching strategy for CI.
3. CI: implement a `build + validate` GitHub Actions workflow using `docker/setup-buildx-action` + `docker/build-push-action` (build only) + `trivy-action` + run `npm test` inside the image using `docker run`.
4. Security scanning: validate Trivy config for GH Actions and add an explicit `fail-on: critical` policy in CI.
5. Secrets checks: ensure CI does not bake secrets into image; validate with an image-layer secrets scanner or `trufflehog` run on build context.
6. Local validation script: create `scripts/validate-container.sh` (or `.ps1`) so developers can run the same sequence locally (build image, run tests, run Trivy).
7. Accessibility: add `jest-axe` unit checks and a Playwright a11y smoke test; verify they run reliably in CI container.

## Outcomes (what to deliver from research)

- Dockerfile (multi-stage) + `devcontainer.json` template
- `scripts/dev-in-container.*` and `scripts/validate-container.*` (cross-platform guidance)
- CI workflow YAML (`.github/workflows/ci-container-validate.yml`) that builds image, runs tests, and scans image
- Acceptance checklist and local reproduction steps for maintainers

## Alternatives considered (short)

- Full dev image (copy source into image) vs bind-mount dev workflow — chose bind-mount for speed during development.
- Alpine base vs slim base — chose slim for compatibility.

---

**Decision record:** All [NEEDS CLARIFICATION] items in spec were resolved: CI will not publish images; CI images are validation-only.
