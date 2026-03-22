#!/usr/bin/env bash
set -euo pipefail

tar -czvf /mnt/hdd/homelab-config-backup-$(date +%F).tar.gz \
 /home/nodezero \
 /etc/caddy \
 /etc/fstab \
 /etc/unbound \
 /etc/samba \
 /etc/pihole \
 /etc/dnsmasq.d
