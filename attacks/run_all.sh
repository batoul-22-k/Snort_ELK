#!/bin/sh
set -e

TARGET="${1:-10.10.0.30}"
WAIT_BETWEEN="${WAIT_BETWEEN:-3}"
WARMUP_TIMEOUT="${WARMUP_TIMEOUT:-60}"
WARMUP_INTERVAL="${WARMUP_INTERVAL:-2}"
HPING_COUNT="${HPING_COUNT:-50}"
HPING_INTERVAL_USEC="${HPING_INTERVAL_USEC:-10000}"

wait_for_http() {
  elapsed=0
  echo "Waiting for target HTTP on $TARGET (timeout ${WARMUP_TIMEOUT}s)..."
  while [ "$elapsed" -lt "$WARMUP_TIMEOUT" ]; do
    if command -v curl >/dev/null 2>&1; then
      curl -s --max-time 2 "http://$TARGET/" >/dev/null 2>&1 && return 0
    else
      wget -qO- "http://$TARGET/" >/dev/null 2>&1 && return 0
    fi
    sleep "$WARMUP_INTERVAL"
    elapsed=$((elapsed + WARMUP_INTERVAL))
  done
  echo "Warning: target HTTP not reachable yet; continuing anyway."
  return 0
}

wait_for_http

echo "[1/5] Network scanning (nmap)"
sh /attacks/nmap_scan.sh "$TARGET" || true
sleep "$WAIT_BETWEEN"

echo "[2/5] DoS-style SYN burst (hping3)"
hping3 -S -p 80 -c "$HPING_COUNT" -i "u$HPING_INTERVAL_USEC" "$TARGET" > /dev/null 2>&1 || true
sleep "$WAIT_BETWEEN"

echo "[3/5] Suspicious/malformed traffic (Xmas/Null)"
sh /attacks/tcp_xmas_scan.sh "$TARGET" || true
sleep "$WAIT_BETWEEN"

echo "[4/5] Suspicious User-Agent (curl/wget)"
curl -A curl -s "http://$TARGET/" > /dev/null 2>&1 || true
wget -qO- "http://$TARGET/" > /dev/null 2>&1 || true
sleep "$WAIT_BETWEEN"

echo "[5/5] HTTP login brute-force (5 POSTs)"
i=1
while [ "$i" -le 5 ]; do
  curl -s -o /dev/null -X POST "http://$TARGET/login" || true
  i=$((i + 1))
done

echo "All attack tests completed."
