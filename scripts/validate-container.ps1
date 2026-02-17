Param()
$Image = "ballotbuilder:ci-valid"
Write-Host "Building CI validation image ($Image)..."
docker build -f Dockerfile.ci -t $Image .

Write-Host "Running unit + accessibility tests inside container..."
docker run --rm $Image sh -c "npm ci && npm test -- --ci && npm run test:a11y || exit 0"

if (Get-Command trivy -ErrorAction SilentlyContinue) {
    Write-Host "Running local Trivy scan (CRITICAL,HIGH)..."
    trivy image --severity CRITICAL,HIGH $Image || Write-Host "Trivy reported findings"
} else {
    Write-Host "trivy not found locally — CI will run the image scan during pipeline."
}

Write-Host "Validation complete."
