#!/bin/sh
TARGET=${1:-172.32.0.30}

# Xmas scan flags (short burst)
hping3 -c 5 -F -P -U -p 80 "$TARGET"

# Null scan (short burst)
hping3 -c 5 -0 -p 80 "$TARGET"
