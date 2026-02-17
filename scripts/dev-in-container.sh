#!/usr/bin/env bash
set -euo pipefail

IMAGE="ballotbuilder:dev"

echo "Building dev image ($IMAGE)..."
docker build -f Dockerfile.dev -t "$IMAGE" .

echo "Starting dev container (bind-mounting project for hot-reload)..."
docker run --rm -it \
  -p 3000:3000 \
  -v "${PWD}:/app" \
  -w /app \
  -e CHOKIDAR_USEPOLLING=true \
  "$IMAGE" npm run dev
