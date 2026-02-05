# Attack Scenarios

## 1) Network Scanning
Objective: Identify live hosts and open services.
Tool: nmap
Commands:
- `nmap -sS -Pn -p 1-1000 172.32.0.30`
- `nmap -sV --script http-useragent -p 80 172.32.0.30`
Expected Snort behavior:
- Alerts for SYN scan bursts (SID 1000001)
- Alert for NSE HTTP probe (SID 1000002)

## 2) DoS-Style Traffic
Objective: Generate high-rate SYNs against a service.
Tool: hping3
Command:
- `hping3 -S --flood -p 80 172.32.0.30`
Expected Snort behavior:
- Rate-based SYN flood alert (SID 1000003)

## 3) Suspicious/Malformed Traffic
Objective: Trigger TCP flag anomalies.
Tool: hping3
Commands:
- `hping3 -F -P -U -p 80 172.32.0.30` (Xmas)
- `hping3 --scan 1-1000 -0 172.32.0.30` (Null)
Expected Snort behavior:
- Alerts for Xmas/Null scans (SIDs 1000004, 1000005)
