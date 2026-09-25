# Installation

## Requirements

| Component | Version / note |
|-----------|----------------|
| OS        | Ubuntu 22.04+, Debian 12+, RHEL/Rocky 9+ |
| Shell     | Bash 4.4+ |
| Tools     | `tar`, `gzip`, `df`, `find`, `systemctl`, `useradd` (present on standard installs) |
| Optional  | `shellcheck` for linting |
| Access    | `sudo` / root for `backup.sh` and `user_manage.sh` |

## Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-account>/linux-server-mgmt.git
   cd linux-server-mgmt
   ```
2. Make the scripts executable (Git normally preserves this bit):
   ```bash
   chmod +x scripts/*.sh
   ```
3. Install the configuration file:
   ```bash
   sudo mkdir -p /etc/linux-server-mgmt
   sudo cp config/server.conf.example /etc/linux-server-mgmt/server.conf
   sudo chmod 600 /etc/linux-server-mgmt/server.conf
   ```
4. (Optional) Install scripts system-wide:
   ```bash
   sudo install -m 755 scripts/*.sh /usr/local/sbin/
   ```
5. (Optional) Schedule jobs with cron (`sudo crontab -e`):
   ```cron
   */15 * * * * /usr/local/sbin/disk_monitor.sh
   0 2 * * *    /usr/local/sbin/backup.sh
   ```

## Verify

```bash
./scripts/system_info.sh
./scripts/disk_monitor.sh; echo "exit code: $?"
```
