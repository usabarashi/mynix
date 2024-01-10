# mynix

My Nix configuration

## Getting started

1. Install nix (and enable flake if needed)
2. Clone this repository

```sh
nix run nixpkgs#git -- clone https://github.com/usabarashi/mynix.git
```

3. Run task
```sh
nix shell nixpkgs#cargo-make -c makers apply
```

## Tasks

```sh
# Apply host nixos/darwin configuration
# Make sure $(hostname) match the osConfiguration target
makers apply

# Format
makers format
```

# References
- [NixOS: A Purely Functional Linux Distribution](https://edolstra.github.io/pubs/nixos-jfp-final.pdf)
- [Nix](https://nixos.org/)
- [Nix Reference Manual](https://nixos.org/manual/nix/stable/introduction.html)
- [https://search.nixos.org/packages](https://search.nixos.org/packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Managing dotfiles with Nix](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
