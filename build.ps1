param(
    [ValidateSet("build", "clean", "shell", "down")]
    [string]$Action = "build"
)

# Ensure the container is up (no-op if already running)
docker compose up -d

switch ($Action) {
    "build" { docker compose exec latex make kidiplom }
    "clean" { docker compose exec latex make clean }
    "shell" { docker compose exec latex bash }
    "down"  { docker compose down }
}
