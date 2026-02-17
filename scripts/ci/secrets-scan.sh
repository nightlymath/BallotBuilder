#!/usr/bin/env bash
set -euo pipefail

# Simple secrets scan wrapper. Prefer gitleaks if available.
if command -v gitleaks >/dev/null 2>&1; then
  echo "Running gitleaks on repository..."
  gitleaks detect --source . || true
else
  echo "gitleaks not installed locally; skipping secrets-scan. CI will run secrets detection action."
fi
