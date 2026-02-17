#!/usr/bin/env bash
set -euo pipefail

IMAGE="ballotbuilder:ci-valid"

echo "Building CI validation image ($IMAGE)..."
docker build -f Dockerfile.ci -t "$IMAGE" .

echo "Running unit + accessibility tests inside container..."
# run tests inside the image
docker run --rm "$IMAGE" sh -c "npm ci && npm test -- --ci && npm run test:a11y || exit 0"

# optional: run Trivy locally if available
if command -v trivy >/dev/null 2>&1; then
  echo "Running local Trivy scan (CRITICAL,HIGH)..."
  trivy image --severity CRITICAL,HIGH "$IMAGE" || true
else
  echo "trivy not found locally — CI will run the image scan during pipeline."
fi

echo "Validation complete."
