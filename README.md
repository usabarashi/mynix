# mynix

My Nix configuration

## Getting started

Install Nix.

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Clone repository.

```sh
nix shell nixpkgs#git -c git clone https://github.com/usabarashi/mynix.git
```

Install my nix Settings.

```sh
nix shell nixpkgs#cargo-make -c makers apply
```

# Delete cache

home-manager の古い世代を削除する

```sh
nix shell github:nix-community/home-manager/release-24.05 -c home-manager expire-generations now
```

ユーザーの古いプロファイルを削除する

```sh
nix-env --delete-generations old
```

システムプロファイルの古いリンクを削除する

```sh
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
```

ガベージコレクションを再実行する

```sh
nix-collect-garbage -d
nix-store --gc
```

# Uninstall

Uninstall nix-darwin

```sh
nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
```

Uninstall Nix.

```sh
/nix/nix-installer uninstall
```

Reboot to reset boot items.

# References

- [Nix](https://nixos.org/)
- [Nix Reference Manual](https://nixos.org/manual/nix/stable/introduction.html)
  - [nix-env --delete-generations](https://nix.dev/manual/nix/2.18/command-ref/nix-env/delete-generations)
- [https://search.nixos.org/packages](https://search.nixos.org/packages)
- [Nix package versions](https://lazamar.co.uk/nix-versions/?)
- [nix-installer](https://github.com/DeterminateSystems/nix-installer)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
  - [Darwin Configuration Options](https://daiderd.com/nix-darwin/manual/index.html)
- [home-manager](https://github.com/nix-community/home-manager)
  - [Home Manager Manual](https://nix-community.github.io/home-manager/)
