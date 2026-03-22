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

## Observations

- Docker uses a dedicated bridge network
- Tailscale provides secure remote overlay
- LAN traffic is routed through Pi-hole → Caddy → services

## Recommendation

Move toward:

- single ingress (Caddy)
- minimal exposed ports
- segmented Docker networks
