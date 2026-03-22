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
