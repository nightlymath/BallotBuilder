# Accessibility (WCAG 2.1 AA) — BallotBuilder

This feature targets WCAG 2.1 AA for the initial scaffold. Automated checks and manual tests should be used together.

Automated checks included in this feature:

- `jest-axe` for unit/component-level checks (threshold: fail on `serious` or `critical` violations)
- Playwright `axe-core` integration for E2E accessibility smoke checks

Keyboard navigation acceptance:
- Tab order reaches the main interactive elements and the page heading receives focus when appropriate.

CI enforcement:
- CI will fail the job when `jest-axe` or Playwright axe checks report `serious` or `critical` violations.

Manual testing guidance:
- Run `npm run test:a11y` or use the Playwright recorder to validate focus order and screen-reader behaviour.
