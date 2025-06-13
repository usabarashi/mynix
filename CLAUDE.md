# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Nix Flake configuration repository for managing macOS systems using **nix-darwin** and **home-manager**. It supports multiple machines with different user configurations:

- **H3JN70RHWY**: Personal machine (user: gen) with development tools
- **Mac093**: Work machine (user: motoki_kamimura) with work-specific tools

## Development Commands

### Initial Setup
```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone and apply configuration
nix shell nixpkgs#git -c git clone https://github.com/usabarashi/mynix.git
nix shell nixpkgs#cargo-make -c makers apply
```

### System Configuration Deployment
```bash
# Auto-detect machine and apply configuration
makers apply

# Deploy to specific machines
makers H3JN70RHWY:apply
makers Mac093:apply
```

### Maintenance Commands
```bash
# Update all dependencies
nix flake update

# Update to specific nixpkgs revision
nix flake lock --update-input nixpkgs --override-input nixpkgs github:nixos/nixpkgs/<REVISION>

# Cleanup old generations
nix shell github:nix-community/home-manager -c home-manager expire-generations now
nix-env --delete-generations old
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old

# Garbage collection
nix-collect-garbage -d
nix-store --gc
```

## Architecture

### Core Structure
- **flake.nix**: Main entry point defining darwinConfigurations for both machines
- **hosts/**: Machine-specific system configurations
- **home/**: User-specific home-manager configurations  
- **modules/**: Reusable configuration modules (darwin/ and shared/)
- **packages/**: Custom package definitions
- **config/**: Static configuration files (aider, claude, colima, direnv, karabiner, opencode, vscode)

### Key Configuration Modules
- **modules/shared/vscode.nix**: VSCode with comprehensive extensions including Claude Code
- **modules/shared/git.nix**: Git configuration with custom cleanup scripts
- **modules/shared/shell.nix**: Zsh and direnv setup with global direnv configuration template
- **config/direnv/**: Global direnv configuration templates and setup instructions
- **modules/shared/llm.nix**: LLM tools (Aider, Claude Code, Opencode) and GitHub MCP server
- **modules/darwin/karabiner.nix**: Keyboard remapping (Caps Lock → Control)

### Machine Differences
- **Personal (H3JN70RHWY)**: Includes Discord, Slack, IINA, Zoom, full development stack
- **Work (Mac093)**: Includes Cyberduck, DBeaver, work-focused tools

## Custom Packages
Located in `packages/` directory:
- **custom-url-schema-iina**: AppleScript app for IINA URL handling
- **alloy-extension-v6**: Alloy VSCode extension (marketplace version 0.7.1 with Alloy 4)
- **docker-compose**: Custom package definition

### Alloy Extension JAR Upgrade
The Alloy extension uses Alloy 4 by default. To upgrade to Alloy 6.2.0:

**Manual Upgrade Steps:**
1. Download Alloy 6.2.0 JAR: `https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v6.2.0/org.alloytools.alloy.dist.jar`
2. Locate VSCode extension directory: `~/.vscode/extensions/ArashSahebolamri.alloy-0.7.1/`
3. Replace `org.alloytools.alloy.dist.jar` with the downloaded file
4. Restart VSCode to apply changes

**Technical Notes:**
- Automatic JAR replacement during Nix build is blocked by persistent CRLF (Windows line ending) issues in the original VSIX package
- The marketplace extension was created on Windows and contains CRLF characters in multiple file types that cause bash script interpretation errors during Nix builds
- Manual processing and rebuilding was attempted but the pure Nix build environment makes it challenging to completely eliminate all CRLF issues
- Manual upgrade provides access to Alloy 6.2.0 features: temporal logic, improved visualizer, new color palettes, enhanced solver support, and command-line interface

**Alternative Installation (Advanced Users):**
- VSCode allows manual installation of VSIX files via "Install from VSIX..." in the Extensions view
- Advanced users can download the original VSIX, manually process it to replace the JAR file, and install the modified version

## Claude Code Configuration

### Global Configuration
- **Configuration Source**: `config/claude/settings.json`
- **Applied via**: `modules/shared/llm.nix`
- **Target Location**: `~/.claude/settings.json`
- **Features**: Environment variables, basic permissions, cleanup settings
- **Permissions**: Restricted bash commands (cat, find, git, ls), WebFetch for GitHub, with security denials for sensitive paths

### MCP Server Setup
- **GitHub MCP Server**: Available through `github-mcp-server` package
- **Configuration**: Manual setup required after applying Nix configuration
- **Recommended scope**: User scope for personal tools across all projects
- **Setup command**: `claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN -s user -- github-mcp-server stdio`

## System Settings
Both machines use consistent macOS settings:
- Dark mode enabled
- Touch ID for sudo
- Asia/Tokyo timezone
- Dock and Finder customizations
- Security and screensaver settings

## Build and Deploy Process
The system uses cargo-make for build orchestration:
- **makers apply**: Auto-detects current machine and deploys configuration
- **Build process**: `nix build .#darwinConfigurations.${HOST}.system` followed by `darwin-rebuild switch`
- Both machines use aarch64-darwin architecture (Apple Silicon)