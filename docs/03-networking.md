# Networking

## Interface Inventory

The report documents the following interfaces:

- `lo`
- `eno1`
- `tailscale0`
- `docker0`
- `br-9fc82ac52769`
- multiple `veth*` interfaces attached to the Compose bridge

## IP Addressing

### Loopback

- `127.0.0.1/8`
- `::1/128`

### Primary LAN Interface

Interface: `eno1`

- IPv4: `192.168.1.181/24`

### Tailscale Interface

Interface: `tailscale0`

- IPv4: `100.65.240.47/32`
- IPv6: `fd7a:115c:a1e0::7b36:f02f/128`

### Docker Default Bridge

Interface: `docker0`

- `172.17.0.1/16`

### Compose Bridge Network

Interface: `br-9fc82ac52769`

- `172.18.0.1/16`

## Routing Table

Documented routes:

- default route via `192.168.1.1` on `eno1`
- `172.17.0.0/16` via `docker0`
- `172.18.0.0/16` via `br-9fc82ac52769`
- `192.168.1.0/24` directly on `eno1`

## Logical Traffic Flow

### Normal LAN Service Access

Client → Pi-hole DNS → Caddy → application port

### Internal Domain Access

Client → resolve `*.home.arpa` to `192.168.1.181` → HTTPS to Caddy → reverse proxy to localhost service

### Remote Access Path

Remote device → Tailscale → NodeZero → internal services

## Port Exposure Inventory

### Compose-Managed Application Ports

| Port | Protocol | Service |
|------|----------|---------|
| 7575 | TCP | Homarr |
| 3002 | TCP | Uptime Kuma (host) → 3001 (container) |
| 8191 | TCP | FlareSolverr |
| 8080 | TCP | qBittorrent Web UI |
| 6881 | TCP/UDP | qBittorrent torrent traffic |
| 8096 | TCP | Jellyfin |
| 5056 | TCP | Jellyseerr (host) → 5055 (container) |
| 9696 | TCP | Prowlarr |
| 7878 | TCP | Radarr |
| 8989 | TCP | Sonarr |

### Reverse Proxy Ports (Caddy)

| Port | Protocol | Service |
|------|----------|---------|
| 80 | TCP | Caddy HTTP |
| 443 | TCP | Caddy HTTPS |
| 2019 | TCP | Caddy admin (localhost only) |

### Host-Native Service Ports

| Port | Protocol | Service |
|------|----------|---------|
| 22 | TCP | SSH |
| 53 | UDP/TCP | Pi-hole FTL (DNS) |
| 139 | TCP | Samba (NetBIOS) |
| 445 | TCP | Samba (SMB) |
| 3000 | TCP | Pi-hole admin backend |
| 5335 | UDP/TCP | Unbound (localhost only) |
| 41641 | UDP | Tailscale |

### Other Observed Listening Services

These are non-homelab services present on the host:

| Port | Protocol | Service |
|------|----------|---------|
| 323 | UDP | Chrony (localhost) |
| 631 | TCP | CUPS (localhost) |
| 4000 | TCP | NoMachine |
| 5353 | UDP | Avahi mDNS |
| 137, 138 | UDP | nmbd (NetBIOS) |

These affect the host attack surface and should be reviewed if hardening is desired.

## Observations

- Docker uses a dedicated bridge network for the Compose stack
- Tailscale provides secure remote overlay
- LAN traffic is routed through Pi-hole → Caddy → services
- Container ports are exposed directly on the host in addition to being reachable via Caddy
- Jellyseerr uses a non-matching host/container port mapping (`5056:5055`); this must be preserved in any rebuild

## Recommendation

Move toward:

- single ingress (Caddy)
- minimal directly-exposed container ports
- UFW enabled to restrict external access to non-Caddy ports
