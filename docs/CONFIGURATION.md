# Configuration

All scripts read the same file: `/etc/linux-server-mgmt/server.conf`
(template: [`config/server.conf.example`](../config/server.conf.example)).
Another file can be passed with `-c <path>` or the `CONFIG` environment variable.
If a variable is missing, the script falls back to its built-in default.

| Variable | Used by | Default | Description |
|----------|---------|---------|-------------|
| `LOG_FILE` | all | `/var/log/linux-server-mgmt.log` | Where log lines are appended |
| `DISK_THRESHOLD` | `disk_monitor.sh` | `85` | Usage % that triggers a WARNING |
| `BACKUP_SOURCE` | `backup.sh` | `/etc` | Space-separated list of directories to archive |
| `BACKUP_DIR` | `backup.sh` | `/var/backups/linux-server-mgmt` | Where archives are stored |
| `BACKUP_RETENTION_DAYS` | `backup.sh` | `7` | Archives older than this are deleted |

## Security notes

- The real config is in `.gitignore` — never commit server-specific values.
- Keep it readable by root only: `chmod 600`.
- The file is `source`d by Bash, so only root must be able to write it.
