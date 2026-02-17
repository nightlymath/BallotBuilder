# data-model.md — Containerize development & CI

## Summary

This feature does not introduce new persistent business data models. The changes are infrastructure and developer-experience focused.

## Entities (non-persistent / infra)

- Developer container

  - Attributes: image-tag, workspace-mount, forwarded-ports, environment-variables
  - Validation rules: must expose port 3000, must allow source bind-mount for hot-reload

- CI image artifact

  - Attributes: image-id, commit-sha, feature-branch, build-timestamp, scan-reports
  - Validation rules: must not contain secrets; must pass security-scan with zero critical findings

- CI pipeline job (container-validate)

  - Attributes: job-id, status, logs, artifact-metadata
  - State transitions: queued → running → passed/failed → archived

- Test suite (existing)
  - Attributes: unit-tests, integration-tests, e2e-tests, accessibility-tests
  - Validation rules: tests must be runnable non-interactively inside the container

## Data flows

No application data model changes. CI artifacts and logs contain metadata (commit SHA, feature number) for traceability.

## State transitions

CI image build lifecycle: build → validate (tests + scans) → (out-of-scope: publish).

---

No DB schema or persistent entity changes are required for this feature.
