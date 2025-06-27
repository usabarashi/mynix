# CLAUDE.md

Personal Nix Flake configuration for macOS using **nix-darwin** + **home-manager** + **mac-app-util**.

## Quick Commands

```bash
# Deploy
export HOST_PURPOSE=PRIVATE  # or WORK
nix shell nixpkgs#cargo-make -c makers apply

# Test
export HOST_PURPOSE=PRIVATE
nix build .#darwinConfigurations.default.system --impure

# Update
nix flake update
```

## Architecture

**3-Category Package Management:**
1. Standard nixpkgs packages
2. Custom packages (packages/flake.nix)
3. External flake inputs (vdh-cli, voicevox-cli)

**Key Files:**
- `flake.nix`: Main entry point
- `lib/`: Independent modules (env, systems, configs, builders)
- `home/`: Environment configs (darwin/, work/)
- `modules/`: Shared functionality
- `packages/`: Custom package definitions

## Environment Variables

- `HOST_PURPOSE` (required): `PRIVATE` or `WORK`
- Auto-detected: `CURRENT_USER`, `MYNIX_REPO_PATH`, `SYSTEM_TYPE`, `ARCH`