# Homarr

## Image

`ghcr.io/homarr-labs/homarr:latest`

## Purpose

Homarr is the main dashboard and front door for the homelab.

## Notes

- Port mapping: `7575:7575`
- Restart policy: `unless-stopped`
- Persistent path: `/home/nodezero/homarr/appdata:/appdata`
- The original report documents a Docker socket mount, which is operationally useful but security-sensitive.

## Security Note

This service currently mounts the Docker socket:

`/var/run/docker.sock`

This provides root-level access to the host and should be treated as a high-risk configuration.

Consider removing or isolating this in future revisions.
