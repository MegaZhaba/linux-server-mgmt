#!/usr/bin/env bash
# run_tests.sh — static checks for every script in scripts/.
# Usage: ./tests/run_tests.sh   (exit code 0 = all checks passed)
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
check() {
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then
        echo "PASS: $desc"
    else
        echo "FAIL: $desc"
        fail=1
    fi
}

for s in scripts/*.sh; do
    check "$s: valid Bash syntax"        bash -n "$s"
    check "$s: has bash shebang"         grep -q '^#!/usr/bin/env bash' "$s"
    check "$s: uses strict mode"         grep -q '^set -euo pipefail' "$s"
    check "$s: has LF line endings"      bash -c "! grep -q $'\r' '$s'"
done

# Regression check: retention must follow the configured policy
check "backup.sh: retention uses BACKUP_RETENTION_DAYS" \
    grep -q -- '-mtime +"$BACKUP_RETENTION_DAYS"' scripts/backup.sh

if command -v shellcheck >/dev/null; then
    check "shellcheck passes" shellcheck scripts/*.sh
else
    echo "SKIP: shellcheck not installed"
fi

exit "$fail"
