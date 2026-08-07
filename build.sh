#!/usr/bin/env bash
set -euo pipefail

action="${1:-build}"

# Ensure the container is up (no-op if already running)
docker compose up -d

case "$action" in
    build) docker compose exec latex make kidiplom ;;
    clean) docker compose exec latex make clean ;;
    shell) docker compose exec latex bash ;;
    down)  docker compose down ;;
    *)
        echo "Usage: $0 [build|clean|shell|down]" >&2
        exit 1
        ;;
esac
