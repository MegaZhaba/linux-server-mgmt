#!/usr/bin/env bash
# service_check.sh — check that critical systemd services are running
# and restart the ones that are down.

SERVICES="nginx ssh cron"

for svc in $SERVICES; do
    if systemctl is-active --quiet $svc; then
        echo "OK: $svc is running"
    else
        echo "FAIL: $svc is not running, restarting..."
        systemctl restart $svc
    fi
done
