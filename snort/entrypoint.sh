#!/bin/sh
set -e

IFACE="${SNORT_INTERFACE:-eth0}"

ip link set dev "$IFACE" promisc on || true
umask 022
mkdir -p /var/log/snort
chown -R snort:snort /var/log/snort || true
chmod 755 /var/log/snort || true
touch /var/log/snort/alert
chmod 644 /var/log/snort/alert || true
exec snort "$@"
