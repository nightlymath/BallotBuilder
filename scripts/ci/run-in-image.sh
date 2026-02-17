#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-ballotbuilder:ci-valid}"

echo "Running tests inside image: $IMAGE"
docker run --rm "$IMAGE" sh -c "npm ci && npm test -- --ci && npm run test:a11y"
