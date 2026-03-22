#!/usr/bin/env bash
set -euo pipefail
cd /home/nodezero/homelab-compose
docker compose pull
docker compose up -d
docker compose ps
