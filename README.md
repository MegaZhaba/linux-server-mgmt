# Linux Server Management Toolkit

Bash scripts and documentation for everyday Linux server administration:
system health reports, disk monitoring, backups with retention, and user
management. Built by a small team using a Git Flow–style workflow.

## Project purpose

Give administrators a small, tested and documented set of tools that can be
installed on any Linux server and scheduled with cron, instead of ad-hoc
commands typed by hand.

## Project structure

```
linux-server-mgmt/
├── scripts/
│   ├── system_info.sh     # health report: OS, load, memory, disk, top processes
│   ├── disk_monitor.sh    # WARNING / CRITICAL alerts on filesystem usage
│   ├── backup.sh          # tar.gz backups with retention policy (root)
│   ├── user_manage.sh     # add / lock / unlock / remove / list users (root)
│   └── service_check.sh   # systemd service health check, optional restart (-r)
├── config/
│   └── server.conf.example  # template for /etc/linux-server-mgmt/server.conf
├── docs/
│   ├── INSTALLATION.md
│   ├── CONFIGURATION.md
│   └── TROUBLESHOOTING.md
├── tests/
│   └── run_tests.sh       # static checks for all scripts
├── .github/pull_request_template.md
├── CONTRIBUTING.md
├── .gitignore             # logs, real configs, secrets, archives
└── .gitattributes         # LF line endings for scripts
```

## Quick start

```bash
git clone https://github.com/<your-account>/linux-server-mgmt.git
cd linux-server-mgmt
sudo cp config/server.conf.example /etc/linux-server-mgmt/server.conf
./scripts/system_info.sh
```

Full guide: [docs/INSTALLATION.md](docs/INSTALLATION.md) ·
settings: [docs/CONFIGURATION.md](docs/CONFIGURATION.md)

## Branching strategy

| Branch | Purpose | Rules |
|--------|---------|-------|
| `main` | Stable releases only | Protected; changes only via PR from `develop` |
| `develop` | Integration of finished features | Changes only via reviewed PRs |
| `feature/<name>` | New functionality | Branch from `develop`, merge back via PR |
| `docs/<name>` | Documentation work | Same as feature |
| `fix/<name>` | Bug fixes / reverts | Branch from `develop` |

Merges use `--no-ff` (merge commits) so every feature stays visible in history.

## Development workflow

1. `git checkout develop && git pull`
2. `git checkout -b feature/<name>`
3. Commit small, meaningful changes
4. `./tests/run_tests.sh`
5. `git push -u origin feature/<name>` → open a PR into `develop`
6. Review → fix comments → approve → merge
7. When `develop` is stable: PR `develop` → `main` and tag a release (`v1.0.0`)

## Contribution process

See [CONTRIBUTING.md](CONTRIBUTING.md): commit message format, PR template
(what / why / how tested) and the code review checklist
(functionality, organization, documentation, problems, maintainability, security).

## Testing process

```bash
./tests/run_tests.sh      # exit code 0 = all checks passed
```

Checks Bash syntax (`bash -n`), shebang, strict mode (`set -euo pipefail`),
LF line endings, runs `shellcheck` if installed, and contains regression
checks for past bugs (e.g. backup retention). Every PR must state which
tests were run. Scripts are also tested manually on a test VM before release.

## Troubleshooting process

1. Reproduce with `bash -x scripts/<name>.sh`
2. Read `/var/log/linux-server-mgmt.log` and the exit code
3. Verify the config file
4. Investigate history: `git log -p -- <file>`, `git blame <file>`, `git bisect`
5. Fix with a new commit, or undo a bad commit with `git revert <hash>`
   (never `git reset` on shared branches — it rewrites history)

Common errors and fixes: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

## Project history highlights

- **Merge conflict** — `feature/disk-critical-level` and
  `feature/tune-disk-threshold` both changed `DISK_THRESHOLD`; resolved by
  keeping the two-level alerting and the 90% warning value.
- **Recovery** — commit *"refactor(backup): simplify retention cleanup"*
  deleted all backups older than 1 day. Found with `tests/run_tests.sh` +
  `git bisect`, undone with `git revert` while keeping later commits.
