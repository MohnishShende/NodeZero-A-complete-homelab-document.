# Security

## Positive Security Properties

- Services are primarily intended to be accessed through internal HTTPS hostnames
- Caddy terminates TLS with internal certificates
- Remote access is available through Tailscale
- Core DNS is local
- Containers are isolated on a Compose bridge network
- Uptime Kuma and Jellyfin health states are good
- No public cloud exposure is implied by the current config

## Observed Security Gaps and Tradeoffs

- UFW is inactive
- application ports are host-exposed directly, even though the preferred access model is via Caddy
- Samba is active and listening on 139 and 445
- NoMachine is installed and listening
- Avahi is active
- desktop stack is active on a server-like host
- `/var/run/docker.sock` is mounted into Homarr, which is useful but privileged
- internal TLS depends on clients trusting the Caddy CA
- current resolver model includes external DNS servers in addition to loopback

## Assessment

The system is reasonably safe for a local homelab, but it is not hardened to a minimalist security posture.

## Recommended Hardening Actions

### Firewall

Enable UFW and restrict access:

~~~bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80,443/tcp
ufw allow from 100.64.0.0/10
~~~

### Remove Direct Port Exposure

Prefer reverse proxy via Caddy instead of exposing container ports directly.

### Docker Socket Risk

Avoid mounting `/var/run/docker.sock` into containers unless absolutely required.

### Samba Restriction

Restrict SMB to LAN subnet only.

### Service Reduction

Disable unnecessary services:

- Avahi
- NoMachine
- CUPS
- Desktop stack

