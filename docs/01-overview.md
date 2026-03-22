# Overview

## Purpose

NodeZero is documented as a single source of truth for four things:

1. Current-state documentation
2. Disaster recovery
3. Rebuild from zero
4. Operational handbook

This repository exists so the system can be understood, maintained, and rebuilt without relying on memory alone.

## Executive Summary

NodeZero is a single-node homelab running Ubuntu 25.10 on x86_64 hardware. It operates as a local-first self-hosted platform for media automation, streaming, monitoring, internal DNS, internal HTTPS, Samba file sharing, and secure remote access.

The application layer is managed through Docker Compose and currently consists of nine active containers:

- Homarr
- Uptime Kuma
- FlareSolverr
- qBittorrent
- Jellyfin
- Jellyseerr
- Prowlarr
- Radarr
- Sonarr

The host layer remains outside containers for core infrastructure services:

- Caddy
- Pi-hole
- Unbound
- Tailscale
- SSH
- Samba
- NetworkManager
- systemd-resolved

## System Identity

- Hostname: `nodezero`
- Primary user: `nodezero`
- Primary Compose directory: `/home/nodezero/homelab-compose`
- Primary LAN IP: `192.168.1.181`
- Primary Tailscale IPv4: `100.65.240.47`
- Primary Tailscale IPv6: `fd7a:115c:a1e0::7b36:f02f`
- Local internal domain: `home.arpa`

## Current Operational Status

The report states that the system is operational and verified.

Verified runtime condition:

- Docker Engine running
- Docker Compose deployed
- 9 of 9 containers running
- Jellyfin healthy
- Uptime Kuma healthy
- Caddy running
- Pi-hole FTL running
- Unbound running
- Tailscale running
- SSH running
- Samba running
- UFW inactive
- Media disk mounted at `/mnt/hdd`

## Verified Reverse Proxy Behavior

The report documents these healthy application responses:

- `https://dashboard.home.arpa` → HTTP 200
- `https://uptime.home.arpa` → HTTP 302
- `https://sonarr.home.arpa` → HTTP 401
- `https://radarr.home.arpa` → HTTP 401
- `https://prowlarr.home.arpa` → HTTP 401
- `https://jellyfin.home.arpa` → HTTP 302
- `https://jellyseerr.home.arpa` → HTTP 307
- `https://qbittorrent.home.arpa` → HTTP 200
- `https://flaresolverr.home.arpa` → HTTP 200

## Truth Model

The underlying report distinguishes between:

- verified directly from live terminal output
- verified earlier in the same session
- not captured verbatim yet

That distinction matters because it keeps the documentation honest and makes rebuild fidelity clearer.
