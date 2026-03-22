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

After any significant change, run through these checks:

**1. Containers:**

```bash
docker ps
docker compose ps
```

Expected: 9 containers, `jellyfin` and `uptime-kuma` showing `(healthy)`.

**2. Reverse proxy (spot check):**

```bash
curl -kI https://dashboard.home.arpa
curl -kI https://uptime.home.arpa
curl -kI https://jellyfin.home.arpa
```

Expected:
- `dashboard.home.arpa` → `HTTP/2 200`
- `uptime.home.arpa` → `HTTP/2 302`
- `jellyfin.home.arpa` → `HTTP/2 302`

**3. DNS:**

```bash
cat /etc/resolv.conf
sudo ss -tulpn | grep -E '(:53|:5335)'
```

Expected: port 53 open on `0.0.0.0`, port 5335 bound to `127.0.0.1`.

**4. Caddy:**

```bash
sudo systemctl status caddy
```

Expected: `Active: active (running)`.

**5. Storage:**

```bash
df -h /mnt/hdd
```

Expected: `/dev/sdc1` mounted, `916G` total.

## Quick Recovery Actions

### Restart All Containers

```bash
cd ~/homelab-compose && docker compose down && docker compose up -d
```

### Restart a Single Container

```bash
cd ~/homelab-compose && docker compose restart <service-name>
```

### Restart Caddy

```bash
sudo systemctl restart caddy
sudo systemctl status caddy
```

### Restart DNS Stack

```bash
sudo systemctl restart pihole-FTL
sudo systemctl restart unbound
sudo ss -tulpn | grep -E '(:53|:5335)'
```

### Tail Logs for a Specific Service

```bash
cd ~/homelab-compose && docker compose logs -f sonarr
```

Replace `sonarr` with any service name.

### Check What's Listening on a Port

```bash
sudo ss -tulpn | grep :<port>
```

### Inspect a Container

```bash
docker inspect <container-name>
```
