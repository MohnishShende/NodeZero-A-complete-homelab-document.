# Prowlarr

## Image

`linuxserver/prowlarr`

## Purpose

Prowlarr is the indexer manager. It provides a central location to configure and manage torrent and Usenet indexers, and syncs them automatically to Sonarr and Radarr.

## Ports

| Host | Container |
|------|-----------|
| 9696 | 9696 |

Accessible via: `https://prowlarr.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `PUID` | `911` |
| `PGID` | `911` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/prowlarr/config` | `/config` |

## Notes

- Expected response: `HTTP 401` (authentication required)
- Ownership of `/home/nodezero/prowlarr` must be `911:911`
- FlareSolverr is configured here as a proxy for Cloudflare-protected indexers
