# mynix

**Declarative user environment that eliminates manual setup by defining your entire development and daily-use software stack as code.**

## Quick Start

```bash
# Install Nix (see: https://github.com/DeterminateSystems/nix-installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone and apply configuration
nix shell nixpkgs#git -c git clone https://github.com/usabarashi/mynix.git
cd mynix

# Set environment variables and apply
export HOST_PURPOSE=PRIVATE  # or WORK (required)
nix shell nixpkgs#cargo-make -c makers apply
```

## Commands

### Testing and Validation
```bash
# Test configuration without applying
export HOST_PURPOSE=PRIVATE
nix build .#darwinConfigurations.default.system --impure --dry-run

# Switch between environments
export HOST_PURPOSE=WORK && makers apply
export HOST_PURPOSE=PRIVATE && makers apply

# Development environments
nix develop .#default    # Standard development shell
nix develop .#debug      # Debug shell with additional tools
```

### Update Dependencies
```bash
nix flake update               # Update all inputs
nix flake lock --update-input nixpkgs --override-input nixpkgs github:nixos/nixpkgs/<REVISION>
```

### Cleanup
```bash
# Remove old generations
nix shell github:nix-community/home-manager -c home-manager expire-generations now
nix-env --delete-generations old
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old

# Garbage collection
nix-collect-garbage -d && nix-store --gc
```

### Validation
```bash
nix flake show                 # Show configuration
find . -name "*.nix" -type f -exec nix-instantiate --parse {} \;  # Syntax check
```

## Configuration

### Environment Variables

| Variable | Required | Values | Makefile.toml | Description |
|----------|----------|--------|---------------|-------------|
| `HOST_PURPOSE` | ✅ | `PRIVATE`, `WORK` | Must be set manually | Determines configuration profile |
| `CURRENT_USER` | ❌ | Auto-detected | Auto-detected via `whoami` | Current user for home directory setup |
| `MYNIX_REPO_PATH` | ❌ | Auto-detected | Auto-detected via `pwd` | Repository path for config references |
| `SYSTEM_TYPE` | ❌ | Auto-detected | Auto-detected via `uname -s` | OS type (e.g., `Darwin`) |
| `ARCH` | ❌ | Auto-detected | Auto-detected via `uname -m` | Architecture (e.g., `arm64`) |

### Build Requirements

- **Build Flag**: `--impure` (required for environment variable access)
- **Platform**: macOS (Darwin) with Apple Silicon (aarch64) or Intel (x86_64)
- **Nix Version**: Compatible with flakes and experimental features

## References

- [Nix](https://nixos.org/) | [Manual](https://nixos.org/manual/nix/stable/) | [Installer](https://github.com/DeterminateSystems/nix-installer)
- [NixOS Search](https://search.nixos.org/packages) | [NixHub](https://www.nixhub.io/) | [Versions](https://lazamar.co.uk/nix-versions/)
- [home-manager](https://github.com/nix-community/home-manager) | [Manual](https://nix-community.github.io/home-manager/)
- [nix-darwin](https://github.com/LnL7/nix-darwin) | [Options](https://daiderd.com/nix-darwin/manual/)
- [mac-app-util](https://github.com/hraban/mac-app-util) | [Documentation](https://github.com/hraban/mac-app-util/blob/main/README.md)
