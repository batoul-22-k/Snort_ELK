#!/bin/sh
set -e

TARGET="${1:-10.10.0.30}"

echo "[1/5] Network scanning (nmap)"
sh /attacks/nmap_scan.sh "$TARGET" || true
sleep 2

echo "[2/5] DoS-style SYN burst (hping3)"
hping3 -S -p 80 -c 200 "$TARGET" > /dev/null 2>&1 || true
sleep 2

echo "[3/5] Suspicious/malformed traffic (Xmas/Null)"
sh /attacks/tcp_xmas_scan.sh "$TARGET" || true
sleep 2

echo "[4/5] Suspicious User-Agent (curl/wget)"
curl -A curl -s "http://$TARGET/" > /dev/null 2>&1 || true
wget -qO- "http://$TARGET/" > /dev/null 2>&1 || true
sleep 1

echo "[5/5] HTTP login brute-force (5 POSTs)"
for i in $(seq 1 5); do
  curl -s -o /dev/null -X POST "http://$TARGET/login" || true
done

echo "All attack tests completed."
