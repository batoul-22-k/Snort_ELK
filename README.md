# Snort 2 Docker IDS Lab

This lab provides a reproducible Snort 2 IDS environment with attacker, target, and ELK visualization.

## Topology (ASCII)
[attacker 10.10.0.20] ---> [target 10.10.0.30]
                         ^
                         |
                  sniffed by [snort-ids]

Logs: snort-ids -> shared volume -> logstash -> elasticsearch -> kibana (10.10.1.0/24)

## Traffic Flow
1. Attacker sends traffic to target on `snortnet`.
2. Snort runs in a separate container but shares the target's network namespace so it can see traffic destined for the target.
3. Snort runs in promiscuous mode and writes alerts to `/var/log/snort`.
4. Logstash parses `/var/log/snort/alert` and indexes into Elasticsearch.
5. Kibana visualizes the alerts.

## Quick Start
1. `docker compose up -d --build`
2. `docker compose exec attacker bash`

## Community Rules
Download the community rules and place them into `snort/rules/community.rules` or mount your own rules directory.

## Attack Scripts (from attacker container)
- `sh /attacks/nmap_scan.sh 10.10.0.30`
- `sh /attacks/hping3_syn_flood.sh 10.10.0.30`
- `sh /attacks/tcp_xmas_scan.sh 10.10.0.30`

## Alert Commands (copy/paste)
Network scanning
1. SYN scan (fallback to connect scan if raw sockets are blocked):
`docker compose exec attacker sh /attacks/nmap_scan.sh 10.10.0.30`
Expected alerts
- SID 1000001: LOCAL Nmap SYN scan
- SID 1000002: LOCAL Nmap NSE HTTP probe

DoS-style traffic
1. SYN flood (stop with Ctrl+C):
`docker compose exec attacker sh /attacks/hping3_syn_flood.sh 10.10.0.30`
Expected alert
- SID 1000003: LOCAL Possible SYN flood

Suspicious/malformed traffic
1. Xmas scan:
`docker compose exec attacker sh /attacks/tcp_xmas_scan.sh 10.10.0.30`
Expected alerts
- SID 1000004: LOCAL TCP Xmas scan
- SID 1000005: LOCAL TCP Null scan

Suspicious User-Agent
1. Curl:
`docker compose exec attacker sh -c "curl -A curl -s http://10.10.0.30/ > /dev/null"`
2. Wget:
`docker compose exec attacker sh -c "wget -qO- http://10.10.0.30/ > /dev/null"`
Expected alert
- SID 1000006: LOCAL Suspicious User-Agent

HTTP login brute-force (lab simulation)
1. Five POSTs to /login:
`docker compose exec attacker sh -c "for i in $(seq 1 5); do curl -s -o /dev/null -X POST http://10.10.0.30/login; done"`
Expected alert
- SID 1000007: LOCAL HTTP login brute-force

## Verify Alerts (CLI)
1. Confirm Snort wrote alerts:
`docker compose exec snort-ids tail -n 10 /var/log/snort/alert`
2. Confirm logs exist on host:
`type logs\\snort\\alert` (Windows PowerShell)
3. Confirm Elasticsearch has documents:
`docker compose exec elasticsearch sh -c "curl -s http://localhost:9200/_cat/indices?v"`
4. Inspect one parsed document:
`docker compose exec elasticsearch sh -c "curl -s http://localhost:9200/snort-alerts-*/_search?size=1"`

## Troubleshooting Missing Fields in Kibana
If Discover shows only `_grokparsefailure` or fields like `signature` are missing:
1. Restart Logstash:
`docker compose up -d --force-recreate logstash`
2. Clear old indices:
`docker compose exec elasticsearch sh -c "curl -s -X DELETE http://localhost:9200/snort-alerts-*"`
3. (Optional) Reset file input state so Logstash re-reads alerts:
`docker compose exec logstash sh -c "rm -f /usr/share/logstash/data/sincedb_snort"`
4. Trigger a new attack:
`docker compose exec attacker sh /attacks/tcp_xmas_scan.sh 10.10.0.30`
5. Refresh Kibana fields:
Stack Management -> Index Patterns -> `snort-alerts-*` -> Refresh field list

## Kibana
Open `http://localhost:5601` and import `kibana/dashboards/snort.ndjson`.

If visualizations complain about missing `signature.keyword`, recreate the index
after applying the template in `logstash/templates/snort-template.json`:
- Restart Logstash
- Delete old `snort-alerts-*` indices
- Re-run an attack to repopulate data

## Logs
- Fast alerts (host path): `logs/snort/alert`
- Other Snort logs (host path): `logs/snort/`
- Unified2: `/var/log/snort/snort.u2.*`
