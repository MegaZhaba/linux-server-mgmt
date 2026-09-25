# Troubleshooting

## General process

1. **Reproduce** — run the script manually with tracing: `bash -x scripts/<name>.sh`
2. **Read the logs** — `tail -n 50 /var/log/linux-server-mgmt.log`
3. **Check the exit code** — `echo $?` right after the run
4. **Check the config** — `sudo cat /etc/linux-server-mgmt/server.conf`
5. **Find the change that broke it** — `git log -p -- scripts/<name>.sh`,
   `git blame`, or `git bisect` (see README → Recovery)

## Common problems

| Symptom | Cause | Fix |
|---------|-------|-----|
| `/usr/bin/env: 'bash\r': No such file or directory` | File saved with Windows CRLF line endings | `sed -i 's/\r$//' scripts/*.sh` (`.gitattributes` prevents this) |
| `Permission denied` when running a script | Missing execute bit | `chmod +x scripts/*.sh` |
| `backup.sh must be run as root` | Script started without sudo | `sudo ./scripts/backup.sh` |
| `tee: /var/log/...: Permission denied` | Normal user cannot write the log | Run with sudo or set `LOG_FILE` to a writable path |
| `disk_monitor.sh` exits with 1 | A filesystem is above `DISK_THRESHOLD` | Check with `df -h`, clean up with `du -sh /* \| sort -h` |
| Backups disappear too early | Wrong `BACKUP_RETENTION_DAYS` or broken cleanup | Check config and `find ... -mtime` line in `backup.sh` |
| Cron job does nothing | cron has a minimal `PATH` | Use absolute paths in crontab, check `grep CRON /var/log/syslog` |
