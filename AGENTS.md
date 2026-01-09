# CLAUDE.md

Personal Nix Flake configuration for macOS using **nix-darwin** + **home-manager**.

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
3. External flake inputs

**Key Files:**

- `flake.nix`: Main entry point
- `lib/`: Independent modules (env, systems, configs, builders)
- `home/`: Environment configs (darwin/, work/)
- `modules/`: Shared functionality
- `packages/`: Custom package definitions

## Environment Variables

- `HOST_PURPOSE` (required): `PRIVATE` or `WORK`
- Auto-detected: `CURRENT_USER`, `MYNIX_REPO_PATH`, `SYSTEM_TYPE`, `ARCH`

## Nix File Formatting

- Formatter: `nixfmt-rfc-style` (aligns with CI validate workflow)
- Scope: Format all `*.nix` files in this repository
- Validate (same as GitHub Actions):
  - `nix shell nixpkgs#cargo-make -c makers validate`
- Format locally:
  - `nix shell nixpkgs#cargo-make -c makers fmt`
  - or directly: `nix shell nixpkgs#nixfmt-rfc-style -c find . -name "*.nix" -type f -exec nixfmt {} \;`
- Check a single file:
  - `nix shell nixpkgs#nixfmt-rfc-style -c nixfmt --check path/to/file.nix`
- Commit policy:
  - Keep formatting-only changes separate from semantic changes
  - Ensure PRs pass `makers validate` before review

### Post-Change Checklist

- After any change (before commit/push), run:
  - `nix shell nixpkgs#cargo-make -c makers validate`
- If validation fails due to formatting, fix with:
  - `nix shell nixpkgs#cargo-make -c makers fmt`
  - then re-run `makers validate`
- CI runs the same validation; unformatted files will fail the build

## Operational Notes

- On macOS, if `nix-store --gc` or `nix-collect-garbage -d` fails with
  "Operation not permitted", run the GC commands from the Terminal app and
  ensure Full Disk Access is enabled (System Settings -> Privacy & Security ->
  Full Disk Access).
