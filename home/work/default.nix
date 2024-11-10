{ lib, pkgs, ... }:

let
  unstable_20240709 = import
    (builtins.fetchGit {
      name = "unstable-20240709";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "05bbf675397d5366259409139039af8077d695ce";
    })
    {
      system = "aarch64-darwin";
    };
  cyberduck = unstable_20240709.cyberduck;

  unstable_20240514 = import
    (builtins.fetchGit {
      name = "unstable-20240514";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb";
    })
    {
      system = "aarch64-darwin";
    };
  dbeaver = unstable_20240514.dbeaver;
in
{
  programs.home-manager.enable = true;
  home = {
    username = "motoki_kamimura";
    homeDirectory = "/Users/motoki_kamimura";
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    cyberduck
    dbeaver
    scala-cli
  ];

  imports = [
    ../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
    ../../modules/shared/shell.nix
  ];

}
