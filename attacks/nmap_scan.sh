#!/bin/sh
TARGET=${1:-172.30.0.30}

# SYN scan (fallback to connect scan if raw sockets are blocked)
if ! nmap -sS -Pn -p 1-1000 "$TARGET"; then
  nmap -sT -Pn -p 1-1000 "$TARGET"
fi

# Service enumeration with NSE HTTP probes
nmap -sV --script http-title,http-headers -p 80 "$TARGET"
