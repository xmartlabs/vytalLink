# Scripts

Repository-level helper scripts live here.

## `setup_wt.sh`

`./scripts/setup_wt.sh` links ignored credential files from one local checkout into another checkout or worktree.

- Run `./scripts/setup_wt.sh` from inside the target worktree.
- Pass `--target /path/to/worktree` when running it from the source checkout.
- Pass `--source /path/to/source/repo` if you want to choose a different source checkout.
