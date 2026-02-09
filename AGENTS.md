# CLAUDE.md

Personal Nix Flake configuration for macOS using **nix-darwin** + **home-manager**.

## Commands

| Command | Description |
|---------|-------------|
| `makers apply` | Build and deploy configuration |
| `makers validate` | Check syntax and formatting (same as CI) |
| `makers fmt` | Auto-format all `*.nix` files |
| `nix flake update` | Update flake dependencies |

All `makers` commands run via `nix shell nixpkgs#cargo-make -c`.

```bash
# Deploy
export HOST_PURPOSE=PRIVATE  # or WORK
nix shell nixpkgs#cargo-make -c makers apply

# Build test (without applying)
export HOST_PURPOSE=PRIVATE  # or WORK
nix build .#darwinConfigurations.default.system --impure
```

## Architecture

```
flake.nix              Entry point - reads HOST_PURPOSE, assembles system
lib/
  env.nix              Environment variable resolution
  configs.nix          Purpose-based config selection (PRIVATE/WORK)
  builders.nix         mkDarwinSystem - composes nix-darwin + home-manager
  overlays.nix         Custom package overlays
hosts/                 System-level nix-darwin config per environment
  private/             PRIVATE: system defaults, blackhole, nix-maintenance
  work/                WORK: system defaults, nix-maintenance
home/                  User-level home-manager config per environment
  darwin/              PRIVATE: personal packages and modules
  work/                WORK: work packages and modules
modules/
  darwin/              nix-darwin modules (blackhole, karabiner, nix-maintenance)
  shared/              home-manager modules (git, terminal, neovim, vscode, llm, ...)
packages/              Custom package definitions
```

### Package Sources

1. Standard nixpkgs packages
2. Custom packages (`packages/`)
3. External flake inputs (voicevox-cli, etc.)

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `HOST_PURPOSE` | Yes | `PRIVATE` or `WORK` |
| `CURRENT_USER` | Auto | Via `whoami` |
| `MYNIX_REPO_PATH` | Auto | Via `pwd` |

## Formatting

- Formatter: `nixfmt-rfc-style`
- Run `makers validate` before commit/push
- If validation fails: run `makers fmt`, then re-validate
- Keep formatting-only changes separate from semantic changes

## Operational Notes

- Build requires `--impure` flag for environment variable access
- Nix store GC runs automatically via launchd (weekly, configured in `modules/darwin/nix-maintenance.nix`).
  Home Manager generations require manual cleanup: `home-manager expire-generations now`
- If manual `nix-store --gc` fails with "Operation not permitted", run from
  Terminal.app with Full Disk Access enabled
  (System Settings > Privacy & Security > Full Disk Access)
