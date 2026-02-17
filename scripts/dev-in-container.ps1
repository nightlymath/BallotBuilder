Param()
Write-Host "Building dev image (ballotbuilder:dev)..."
docker build -f Dockerfile.dev -t ballotbuilder:dev .

Write-Host "Starting dev container (bind-mounting project for hot-reload)..."
$pwdPath = (Get-Location).Path
docker run --rm -it -p 3000:3000 -v "${pwdPath}:/app" -w /app -e CHOKIDAR_USEPOLLING=true ballotbuilder:dev npm run dev
