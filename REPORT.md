# Snort 2 IDS Lab Report (Outline)

## 1. Introduction
- Problem statement and goals
- Scope and assumptions

## 2. Tool Justification
- Snort 2 (signature-based IDS)
- Docker (reproducible lab)
- ELK stack (searchable analytics)

## 3. Architecture
- Container roles and responsibilities
- Network segmentation (`snortnet` vs `monitornet`)
- ASCII topology diagram

## 4. Configuration
- Snort settings (HOME_NET, preprocessors, outputs)
- Rule management (community + custom SIDs)
- Logstash parsing pipeline

## 5. Attacks & Testing
- Attack 1: Nmap SYN scan and service enumeration
- Attack 2: DoS-style SYN flood (hping3)
- Attack 3: TCP flag anomalies (Xmas/Null)
- Expected alerts and observed alerts

## 6. Visualization
- Kibana dashboards
- Alert count over time
- Attack type distribution
- Top source IPs and target ports

## 7. Results & Analysis
- Detection accuracy per attack (example table below)

| Attack | Expected Alerts | Observed Alerts | Detection Rate | Notes |
|---|---|---|---|---|
| Nmap SYN | 1+ | TBD | TBD | Threshold-based |
| DoS SYN flood | 1+ | TBD | TBD | Rate-based |
| Xmas/Null | 1+ | TBD | TBD | Flag-based |

- False positives / false negatives
- Performance considerations (CPU, packet drops, log volume)
- Limitations of Snort 2 (encrypted traffic, evasion, signature maintenance)
- Possible evasions (fragmentation, slow scans, traffic shaping, TLS)

## 8. Conclusion
- Summary of findings
- Future improvements (Snort 3, Suricata, Zeek, TLS inspection)


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