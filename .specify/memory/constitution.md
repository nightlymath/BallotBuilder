<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0
- Modified / added principles:
  - Test-First & Continuous Verification (expanded to REQUIRE TDD + BDD for customer-facing/business flows)
- Added/changed guidance: Explicit TDD requirement; BDD for acceptance criteria and customer flows
- Templates updated: .specify/templates/spec-template.md ✅ updated, .specify/templates/plan-template.md ✅ updated, .specify/templates/tasks-template.md ✅ updated
- Follow-up TODOs: none
-->

# BallotBuilder Constitution

## Core Principles

### Security & Privacy (NON-NEGOTIABLE)
- All production ballot and voter data MUST be treated as sensitive. Data at rest MUST be encrypted (AES-256 or equivalent) and data in transit MUST use TLS 1.2+.
- Personal Identifiable Information (PII) MUST be minimised and stored only when explicitly required by the feature spec; each retention period MUST be documented in the spec.
- Access to sensitive data MUST follow least-privilege principles and every access MUST be auditable.
- Rationale: Electoral systems require confidentiality and integrity by design; security is not optional.

### Verifiability & Auditability
- All ballot operations that affect outcome, state, or metadata MUST produce an auditable, exportable record.
- System design MUST enable independent verification of ballot integrity (cryptographic receipts, immutable logs, or equivalent) where applicable.
- Audit logs MUST be tamper-evident, retained according to the feature's retention policy, and include enough context for forensic reconstruction.
- Rationale: Trust in results depends on reproducible, inspectable evidence of system behaviour.

### Test-First & Continuous Verification (NON-NEGOTIABLE)
- Development MUST follow Test-Driven Development (TDD) practices: write failing unit/contract tests first, implement the minimal code to make them pass, then refactor.
- For customer-facing functionality or business requirements, Behaviour-Driven Development (BDD) MUST be used to define human-readable acceptance scenarios (Gherkin or equivalent) that are executable as acceptance tests.
- Every new feature or change MUST include tests that define expected behaviour before implementation (unit, contract, integration, and BDD acceptance tests as appropriate).
- CI pipelines MUST gate merges: tests MUST run and pass; contract, integration, and BDD acceptance tests MUST be included for cross-component changes.
- Acceptance criteria in the spec MUST be expressed as verifiable tests and, for user-visible/business flows, as BDD scenarios linked from the spec.
- Rationale: TDD ensures correctness and good design at the unit/contract level; BDD aligns implementation with stakeholder expectations and produces executable acceptance criteria.

### Accessibility & Usability
- User-facing functionality MUST conform to WCAG 2.1 AA (or better) and provide keyboard and screen-reader access where applicable.
- UX flows for ballot creation/selection MUST be simple, reduce chance of user error, and include measurable success criteria in the spec.
- Rationale: Democratic tools must be accessible to all eligible users.

### Simplicity, Observability & Semantic Versioning
- Designs MUST prefer the simplest solution that satisfies requirements (YAGNI + clear failure modes).
- Observability (structured logging, metrics, traces) MUST be implemented for critical flows and exposed in the runbook.
- Releases MUST follow semantic versioning: MAJOR.MINOR.PATCH. Breaking changes to public contracts MUST increment MAJOR and include a migration plan.
- Rationale: Simplicity reduces risk; observability enables diagnosis; semantic versioning communicates compatibility.

## Security & Compliance Requirements
- Encryption: All secrets and sensitive fields MUST be encrypted at rest and in transit.
- Data minimisation: Specs MUST declare PII collected and justify retention; automatic purging MUST be supported where feasible.
- Regulatory compliance: Where applicable (e.g., data protection laws, election regulations), the spec MUST reference required controls and compliance checks.
- Incident handling: Each service MUST include an incident response runbook and contact list in its operational documentation.

## Development Workflow & Quality Gates
- PRs MUST include a link to the feature spec, tests demonstrating compliance with the constitution, and a brief risk assessment.
- Code review: Every change MUST be reviewed by at least one peer; security- or privacy-impacting changes MUST be approved by a designated reviewer.
- Release process: Every release MUST include changelog entries that identify breaking changes, migration steps, and version bump category.
- Constitution Check: New features MUST explicitly document how they satisfy Security, Verifiability, Testing (TDD/BDD), Accessibility, and Versioning principles before Phase 1 completion.

## Governance
- The constitution is the authoritative guidance for project decisions; adherence is mandatory for all work.
- Amendments: Changes to this document MUST be proposed as a PR with a clear rationale, tests/checklist for compliance, and a migration/rollback plan where required.
  - Approval: Amendments that only clarify language or fix typos → PATCH. Additive, non-breaking principles or sections → MINOR. Changes that remove or redefine existing principles → MAJOR. Final approval requires at least two maintainers' approvals or a documented consensus.
- Compliance reviews: Significant features (security/privacy/high-risk) MUST undergo an explicit constitution compliance review before merge.
- Versioning policy: Follow semantic versioning for the constitution itself. Bump MAJOR for incompatible governance changes, MINOR for added principles or material expansions (e.g., TDD/BDD requirement), PATCH for wording/clarity fixes.

**Version**: 1.1.0 | **Ratified**: 2026-02-16 | **Last Amended**: 2026-02-16

