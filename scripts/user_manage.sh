#!/usr/bin/env bash
# user_manage.sh — create, lock, unlock, remove or list Linux user accounts.
# Usage: sudo user_manage.sh {add|lock|unlock|remove|list} [username]
set -euo pipefail

usage() { echo "Usage: $0 {add|lock|unlock|remove|list} [username]" >&2; exit 1; }

[[ $EUID -eq 0 ]] || { echo "user_manage.sh must be run as root" >&2; exit 1; }

action="${1:-}"
user="${2:-}"
[[ -n "$action" ]] || usage

# Validate the username to avoid passing unexpected input to useradd/userdel
if [[ "$action" != "list" ]]; then
    [[ "$user" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]] || { echo "Invalid username: '$user'" >&2; exit 1; }
fi

case "$action" in
    add)
        if id "$user" &>/dev/null; then
            echo "User $user already exists" >&2
            exit 1
        fi
        useradd -m -s /bin/bash "$user"
        passwd -e "$user" >/dev/null   # force password change on first login
        echo "Created $user. Set a password with: passwd $user"
        ;;
    lock)   usermod -L "$user" && echo "Locked $user" ;;
    unlock) usermod -U "$user" && echo "Unlocked $user" ;;
    remove)
        read -rp "Remove $user and its home directory? [y/N] " answer
        [[ "$answer" == [yY] ]] || { echo "Aborted"; exit 0; }
        userdel -r "$user" && echo "Removed $user"
        ;;
    list)
        awk -F: '$3 >= 1000 && $1 != "nobody" {print $1, $6, $7}' /etc/passwd
        ;;
    *) usage ;;
esac
