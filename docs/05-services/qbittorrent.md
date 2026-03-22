# qBittorrent

## Image

`lscr.io/linuxserver/qbittorrent`

## Purpose

qBittorrent is the downloader for the media pipeline. It receives download jobs from Sonarr and Radarr, writes to `/mnt/hdd/downloads`, and exposes a Web UI for manual management.

## Ports

| Host | Container | Purpose |
|------|-----------|---------|
| 8080 | 8080 | Web UI |
| 6881 | 6881/tcp | Torrent traffic |
| 6881 | 6881/udp | Torrent traffic |

Accessible via: `https://qbittorrent.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `PUID` | `1000` |
| `PGID` | `1000` |
| `WEBUI_PORT` | `8080` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/qbittorrent/config` | `/config` |
| `/mnt/hdd/downloads` | `/downloads` |

## Notes

- Uses `PUID=1000`/`PGID=1000` (matches `nodezero` user UID)
- Sonarr and Radarr also mount `/mnt/hdd/downloads` as `/downloads` — this shared path is required for hardlink-based imports
- Expected response: `HTTP 200`
