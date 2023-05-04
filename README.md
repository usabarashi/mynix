# Nix Home Manager

# Set up

```console
% curl -L https://nixos.org/nix/install | sh
% nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
% nix-channel --update
% nix-shell '<home-manager>' -A install
% printenv | grep NIX
```

# Edit

```console
% vi ~/.config/home-manager/home.nix
```

# Activate

```console
% home-manager switch
```

# References
- [Nix](https://nixos.org/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Managing dotfiles with Nix](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)