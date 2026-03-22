# Runbook

## Standard Compose Lifecycle Commands

### Start Stack

~~~bash
cd ~/homelab-compose && docker compose up -d
~~~

### Stop Stack

~~~bash
cd ~/homelab-compose && docker compose down
~~~

### Check State

~~~bash
cd ~/homelab-compose && docker compose ps
~~~

### Tail Logs

~~~bash
cd ~/homelab-compose && docker compose logs --tail 100
~~~

## Validation Commands

### Check Reverse-Proxied Endpoints

~~~bash
curl -kI https://dashboard.home.arpa
curl -kI https://uptime.home.arpa
curl -kI https://sonarr.home.arpa
curl -kI https://radarr.home.arpa
curl -kI https://prowlarr.home.arpa
curl -kI https://jellyfin.home.arpa
curl -kI https://jellyseerr.home.arpa
curl -kI https://qbittorrent.home.arpa
curl -kI https://flaresolverr.home.arpa
~~~

### Check Open Ports

~~~bash
sudo ss -tulpn
~~~

### Check Container Status

~~~bash
docker ps
docker compose ps
~~~

## Update Workflow

~~~bash
cd ~/homelab-compose && docker compose pull && docker compose up -d
~~~

## Post-Change Validation Checklist

1. Check containers
2. Check reverse proxy
3. Check DNS
4. Check Caddy
5. Check storage
