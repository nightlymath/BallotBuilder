# quickstart.md — Dev-in-container & local validation

## Quickstart (developer)

Prereqs: Docker Desktop (or compatible runtime) and Git. Node is optional for local host runs but _not_ required inside container.

1. Build the dev image (local):

   - PowerShell / Windows:

     ```powershell
     docker build -f Dockerfile.dev -t ballotbuilder:dev .
     ```

   - macOS / Linux:
     ```bash
     docker build -f Dockerfile.dev -t ballotbuilder:dev .
     ```

2. Run the app (bind-mounted for hot-reload):

   ```bash
   docker run --rm -it -p 3000:3000 -v "${PWD}:/app" -w /app -e NODE_ENV=development ballotbuilder:dev npm run dev
   ```

   - Open http://localhost:3000
   - Set breakpoints in your editor attached to the container (see `devcontainer.json` instructions).

3. Run unit tests inside the container:

   ```bash
   docker run --rm -v "${PWD}:/app" -w /app ballotbuilder:dev npm test
   ```

4. Run accessibility checks (example):

   ```bash
   docker run --rm -v "${PWD}:/app" -w /app ballotbuilder:dev npm run test:a11y
   ```

## Reproduce CI validation locally

- Build validation image and run the validation steps locally (same steps CI will perform):

  ```bash
  # build the image used for validation
  docker build -f Dockerfile.ci -t ballotbuilder:ci-valid .

  # run unit + integration + accessibility tests inside image
  docker run --rm -v "${PWD}:/app" -w /app ballotbuilder:ci-valid sh -c "npm test && npm run test:a11y"

  # run a local Trivy scan (requires trivy installed locally)
  trivy image --severity CRITICAL,HIGH ballotbuilder:ci-valid
  ```

## VS Code Dev Container (optional)

- Add `.devcontainer/devcontainer.json` (recommended). Use `Remote - Containers` to open workspace in the configured container.

## Notes & troubleshooting

- If hot-reload does not detect file changes on Windows, verify volume mount options and enable polling (Next.js supports CHOKIDAR_USEPOLLING env).
- CI will _not_ publish images as part of this feature; CI validation is read-only for image artifacts.

---

See `specs/002-dockerize-app/spec.md` and `specs/002-dockerize-app/research.md` for implementation details and acceptance criteria.
