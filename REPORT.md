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
