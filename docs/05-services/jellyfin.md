# Jellyfin

## Image

`jellyfin/jellyfin`

## Purpose

Jellyfin is the media server. It serves movies and TV shows from the data disk to clients on the LAN and over Tailscale.

## Ports

| Host | Container |
|------|-----------|
| 8096 | 8096 |

Accessible via: `https://jellyfin.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `JELLYFIN_DATA_DIR` | `/config` |
| `JELLYFIN_CACHE_DIR` | `/cache` |
| `JELLYFIN_CONFIG_DIR` | `/config/config` |
| `JELLYFIN_LOG_DIR` | `/config/log` |
| `JELLYFIN_WEB_DIR` | `/jellyfin/jellyfin-web` |
| `JELLYFIN_FFMPEG` | `/usr/lib/jellyfin-ffmpeg/ffmpeg` |
| `XDG_CACHE_HOME` | `/cache` |
| `MALLOC_TRIM_THRESHOLD_` | `131072` |
| `NVIDIA_VISIBLE_DEVICES` | `all` |
| `NVIDIA_DRIVER_CAPABILITIES` | `compute,video,utility` |
| `LD_PRELOAD` | `/usr/lib/jellyfin/libjemalloc.so.2` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/jellyfin/cache` | `/cache` |
| `/home/nodezero/jellyfin/config` | `/config` |
| `/mnt/hdd` | `/media` |

The entire `/mnt/hdd` tree is exposed as `/media`, allowing multiple libraries (movies, tv, downloads) under one mount.

## Health State

Reported as `healthy` in live system.

## Notes

- NVIDIA environment variables are present in the config but do not by themselves confirm active hardware transcoding
- Expected response: `HTTP 302` redirect to web UI
