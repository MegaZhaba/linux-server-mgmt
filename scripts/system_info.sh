#!/usr/bin/env bash
# system_info.sh — print a short health report of the server.
# Usage: system_info.sh
set -euo pipefail

echo "=== System report: $(hostname) — $(date '+%Y-%m-%d %H:%M:%S') ==="
echo "OS:      $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel:  $(uname -r)"
echo "Uptime:  $(uptime -p)"
echo "Load:    $(cut -d' ' -f1-3 /proc/loadavg)"
echo
echo "--- Memory ---"
free -h
echo
echo "--- Disk ---"
df -h -x tmpfs -x devtmpfs
echo
echo "--- Top 5 processes by memory ---"
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -n 6
