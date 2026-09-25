#!/usr/bin/env bash
# disk_monitor.sh — alert when any filesystem exceeds usage thresholds.
# Usage: disk_monitor.sh [-c config]
# Exit codes: 0 = OK, 1 = warning, 2 = critical
set -euo pipefail

CONFIG="${CONFIG:-/etc/linux-server-mgmt/server.conf}"
[[ "${1:-}" == "-c" && -n "${2:-}" ]] && CONFIG="$2"
# shellcheck source=/dev/null
[[ -f "$CONFIG" ]] && source "$CONFIG"

DISK_THRESHOLD="${DISK_THRESHOLD:-80}"
DISK_CRITICAL="${DISK_CRITICAL:-95}"
LOG_FILE="${LOG_FILE:-/var/log/linux-server-mgmt.log}"

log() { echo "$(date '+%F %T') [disk_monitor] $*" | tee -a "$LOG_FILE"; }

status=0
while read -r mount usage; do
    usage="${usage%\%}"
    if (( usage >= DISK_CRITICAL )); then
        log "CRITICAL: $mount is ${usage}% full (critical ${DISK_CRITICAL}%)"
        status=2
    elif (( usage >= DISK_THRESHOLD )); then
        log "WARNING: $mount is ${usage}% full (threshold ${DISK_THRESHOLD}%)"
        status=$(( status > 1 ? status : 1 ))
    fi
done < <(df -P -x tmpfs -x devtmpfs | awk 'NR>1 {print $6, $5}')

(( status == 0 )) && log "OK: all filesystems below ${DISK_THRESHOLD}%"
exit "$status"
