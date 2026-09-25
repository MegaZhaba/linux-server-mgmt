# Contributing

1. Create a branch from `develop`: `git checkout -b feature/<short-name> develop`
2. Make small commits with clear messages (see *Commit messages* below).
3. Run `./tests/run_tests.sh` before pushing.
4. Push and open a Pull Request into `develop`. Fill in the PR template:
   what changed, why, how it was tested.
5. At least one reviewer must approve. Address every review comment
   with a new commit (do not force-push over reviewed code).
6. The reviewer merges with a merge commit.

## Commit messages

Format: `<type>(<scope>): <summary>` — e.g. `feat(backup): add retention policy`.

| Type | Use for |
|------|---------|
| `feat` | new functionality |
| `fix` | bug fix |
| `docs` | documentation only |
| `test` | tests |
| `refactor` | code change without behaviour change |
| `chore` / `config` | repository or configuration maintenance |

## Review checklist

- **Functionality** — does it do what the PR says? Edge cases?
- **Organization** — right place, consistent with other scripts?
- **Documentation** — usage header, README/docs updated?
- **Potential problems** — error handling, exit codes, unquoted variables
- **Maintainability** — readable, configurable, no hard-coded values
- **Security** — root checks, input validation, no secrets, safe deletes
