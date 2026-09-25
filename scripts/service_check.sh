#!/usr/bin/env bash
# service_check.sh — check that critical systemd services are running.
# Usage: service_check.sh [-r] [-c config]
#   -r  restart services that are down (requires root)
# Exit codes: 0 = all running, 1 = at least one service is down
set -euo pipefail

CONFIG="${CONFIG:-/etc/linux-server-mgmt/server.conf}"
RESTART=false
while getopts "rc:" opt; do
    case "$opt" in
        r) RESTART=true ;;
        c) CONFIG="$OPTARG" ;;
        *) echo "Usage: $0 [-r] [-c config]" >&2; exit 1 ;;
    esac
done
# shellcheck source=/dev/null
[[ -f "$CONFIG" ]] && source "$CONFIG"

SERVICES="${SERVICES:-ssh cron}"
LOG_FILE="${LOG_FILE:-/var/log/linux-server-mgmt.log}"

log() { echo "$(date '+%F %T') [service_check] $*" | tee -a "$LOG_FILE"; }

if [[ "$RESTART" == true && $EUID -ne 0 ]]; then
    echo "service_check.sh -r must be run as root" >&2
    exit 1
fi

status=0
for svc in $SERVICES; do
    if systemctl is-active --quiet "$svc"; then
        log "OK: $svc is running"
        continue
    fi
    status=1
    log "FAIL: $svc is not running"
    if [[ "$RESTART" == true ]]; then
        if systemctl restart "$svc"; then
            log "RESTARTED: $svc"
        else
            log "ERROR: failed to restart $svc"
        fi
    fi
done
exit "$status"
