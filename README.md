# NodeZero

A fully reproducible self-hosted homelab infrastructure built on Ubuntu, Docker, Pi-hole, Unbound, Caddy, Tailscale, and Samba.

> This repository documents the live state, rebuild process, and operational model of NodeZero.

## Features

- Internal DNS via Pi-hole and Unbound
- Internal HTTPS via Caddy with `home.arpa`
- Compose-managed media stack
- Remote access through Tailscale
- Monitoring through Uptime Kuma
- Rebuild-from-zero documentation
- Backup and recovery guidance

## Core Services

- Homarr
- Uptime Kuma
- FlareSolverr
- qBittorrent
- Jellyfin
- Jellyseerr
- Prowlarr
- Radarr
- Sonarr

## Documentation

Detailed documentation lives in `docs/`:

- `docs/01-overview.md`
- `docs/02-architecture.md`
- `docs/03-networking.md`
- `docs/04-dns-and-https.md`
- `docs/05-services/`
- `docs/06-security.md`
- `docs/07-backups.md`
- `docs/08-recovery.md`
- `docs/09-runbook.md`

## Repository Layout

~~~text
docs/
docker/
caddy/
dns/
scripts/
assets/
~~~

## Status

According to the current report, NodeZero is operational, stable, maintainable, and rebuildable from documented state.

## Notes

- This repo documents the live system as of 22 March 2026.
- Sensitive values from the original report are intentionally not reproduced verbatim here.
- The exact contents of `02-home-arpa.conf` were not captured in the source report and should be added later.
