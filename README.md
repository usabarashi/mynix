# mynix

Declarative macOS environment using **nix-darwin** + **home-manager**.
Define your entire development and daily-use software stack as code.

## Quick Start

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone and apply
git clone https://github.com/usabarashi/mynix.git
cd mynix
export HOST_PURPOSE=PRIVATE  # or WORK
nix shell nixpkgs#cargo-make -c makers apply
```

## Commands

| Command | Description |
|---------|-------------|
| `makers apply` | Build and apply configuration |
| `makers validate` | Check syntax and formatting |
| `makers fmt` | Auto-format all Nix files |
| `nix flake update` | Update flake dependencies |
| `nix flake show` | Show current configuration |

All `makers` commands run via `nix shell nixpkgs#cargo-make -c`.

### Dry Run

```bash
export HOST_PURPOSE=PRIVATE  # or WORK
nix build .#darwinConfigurations.default.system --impure --dry-run
```

### Manual GC

System store GC runs automatically via launchd (`nix.gc`).
For a full cleanup including Home Manager and user profiles:

```bash
nix shell github:nix-community/home-manager -c home-manager expire-generations now
nix-env --delete-generations old
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
nix-collect-garbage -d && nix-store --gc
```

> On macOS, if GC fails with "Operation not permitted", run from the Terminal app
> with Full Disk Access enabled (System Settings > Privacy & Security > Full Disk Access).

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `HOST_PURPOSE` | Yes | `PRIVATE` or `WORK` - selects configuration profile |
| `CURRENT_USER` | Auto | Detected via `whoami` |
| `MYNIX_REPO_PATH` | Auto | Detected via `pwd` |
| `SYSTEM_TYPE` | Auto | Detected via `uname -s` |
| `MACHINE_ARCH` | Auto | Detected via `uname -m` |

## Build Requirements

- **Platform**: macOS (Darwin) with Apple Silicon (aarch64)
- **Build flag**: `--impure` (required for environment variable access)
- **Nix**: Flakes enabled

## References

- [Nix](https://nixos.org/) | [Manual](https://nixos.org/manual/nix/stable/) | [Installer](https://github.com/DeterminateSystems/nix-installer)
- [NixOS Search](https://search.nixos.org/packages) | [NixHub](https://www.nixhub.io/) | [Versions](https://lazamar.co.uk/nix-versions/)
- [home-manager](https://github.com/nix-community/home-manager) | [Manual](https://nix-community.github.io/home-manager/)
- [nix-darwin](https://github.com/LnL7/nix-darwin) | [Options](https://daiderd.com/nix-darwin/manual/)
