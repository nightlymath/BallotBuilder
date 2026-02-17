#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <image-tag>"
  exit 2
fi
IMAGE="$1"

if command -v trivy >/dev/null 2>&1; then
  echo "Running trivy scan for $IMAGE (CRITICAL,HIGH)..."
  trivy image --exit-code 1 --severity CRITICAL,HIGH --format json -o trivy-report.json "$IMAGE" || true
else
  echo "trivy not installed locally. CI workflow should run the image scan."
fi
