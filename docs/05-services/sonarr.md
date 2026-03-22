# Sonarr

## Image

`linuxserver/sonarr`

## Purpose

Sonarr handles television automation, import, and organization. It monitors for wanted TV episodes, sends download jobs to qBittorrent via Prowlarr-managed indexers, and imports completed files into the TV library.

## Ports

| Host | Container |
|------|-----------|
| 8989 | 8989 |

Accessible via: `https://sonarr.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `PUID` | `911` |
| `PGID` | `911` |
| `SONARR_CHANNEL` | `v4-stable` |
| `SONARR_BRANCH` | `main` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/sonarr/config` | `/config` |
| `/mnt/hdd/downloads` | `/downloads` |
| `/mnt/hdd/tv` | `/tv` |

## Notes

- Uses `PUID=911`/`PGID=911` — ownership of `/home/nodezero/sonarr` must be `911:911`
- Shares the `/downloads` path with qBittorrent and Radarr for hardlink-based imports
- Pinned to v4-stable channel
- Expected response: `HTTP 401` (authentication required)
