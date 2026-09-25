#!/usr/bin/env bash
# disk_monitor.sh — warn when any filesystem exceeds the usage threshold.
# Usage: disk_monitor.sh [-c config]
# Exit codes: 0 = OK, 1 = warning
set -euo pipefail

CONFIG="${CONFIG:-/etc/linux-server-mgmt/server.conf}"
[[ "${1:-}" == "-c" && -n "${2:-}" ]] && CONFIG="$2"
# shellcheck source=/dev/null
[[ -f "$CONFIG" ]] && source "$CONFIG"

DISK_THRESHOLD="${DISK_THRESHOLD:-85}"
LOG_FILE="${LOG_FILE:-/var/log/linux-server-mgmt.log}"

log() { echo "$(date '+%F %T') [disk_monitor] $*" | tee -a "$LOG_FILE"; }

status=0
while read -r mount usage; do
    usage="${usage%\%}"
    if (( usage >= DISK_THRESHOLD )); then
        log "WARNING: $mount is ${usage}% full (threshold ${DISK_THRESHOLD}%)"
        status=1
    fi
done < <(df -P -x tmpfs -x devtmpfs | awk 'NR>1 {print $6, $5}')

(( status == 0 )) && log "OK: all filesystems below ${DISK_THRESHOLD}%"
exit "$status"
