#!/usr/bin/env bash
# backup.sh — create a compressed archive of configured directories
# and remove archives older than BACKUP_RETENTION_DAYS.
# Usage: sudo backup.sh [-c config]
set -euo pipefail

CONFIG="${CONFIG:-/etc/linux-server-mgmt/server.conf}"
[[ "${1:-}" == "-c" && -n "${2:-}" ]] && CONFIG="$2"
# shellcheck source=/dev/null
[[ -f "$CONFIG" ]] && source "$CONFIG"

BACKUP_SOURCE="${BACKUP_SOURCE:-/etc}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/linux-server-mgmt}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"
LOG_FILE="${LOG_FILE:-/var/log/linux-server-mgmt.log}"

log() { echo "$(date '+%F %T') [backup] $*" | tee -a "$LOG_FILE"; }

if [[ $EUID -ne 0 ]]; then
    echo "backup.sh must be run as root" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"
archive="$BACKUP_DIR/backup-$(hostname)-$(date +%Y%m%d-%H%M%S).tar.gz"

log "Starting backup of: $BACKUP_SOURCE"
# shellcheck disable=SC2086  # word splitting of BACKUP_SOURCE is intended
tar -czf "$archive" $BACKUP_SOURCE 2>>"$LOG_FILE"
log "Created $archive ($(du -h "$archive" | cut -f1))"

# Retention: delete archives older than BACKUP_RETENTION_DAYS days
deleted=$(find "$BACKUP_DIR" -name 'backup-*.tar.gz' -type f -mtime +"$BACKUP_RETENTION_DAYS" -print -delete | wc -l)
log "Retention: removed $deleted archive(s) older than $BACKUP_RETENTION_DAYS days"
