# Nix Home Manager

# Set up

```console
% curl -L https://nixos.org/nix/install | sh
% nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
% nix-channel --update
% nix-shell '<home-manager>' -A install
% printenv | grep NIX
```

# REPL

```console
% nix repl
Welcome to Nix 2.15.0. Type :? for help.

nix-repl> builtins.currentSystem
"aarch64-darwin"

nix-repl> :l <nixpkgs>
Added 18934 variables.

nix-repl> pkgs.stdenv.isAarch64
true

nix-repl> :q
%
```

# Edit

```console
% vi ~/.config/home-manager/home.nix
```

# Activate

```console
% home-manager switch
```

# macOS troubleshoot

- [macOS updates often break nix installation (updates replace path-hooks on multi-user install)](https://github.com/NixOS/nix/issues/3616)

## Workaround in single-user mode only
~/.zshrc
```shell
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

# References
- [NixOS: A Purely Functional Linux Distribution](https://edolstra.github.io/pubs/nixos-jfp-final.pdf)
- [Nix](https://nixos.org/)
- [Nix Reference Manual](https://nixos.org/manual/nix/stable/introduction.html)
- [https://search.nixos.org/packages](https://search.nixos.org/packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Managing dotfiles with Nix](https://alexpearce.me/2021/07/managing-dotfiles-with-nix/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)