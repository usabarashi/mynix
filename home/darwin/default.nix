{ lib, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "gen";
    homeDirectory = "/Users/gen";
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "slack"
    "vscode"
    "zoom"
  ];

  home.packages = with pkgs; [
    discord
    iina
    scala-cli
    slack
    zoom-us
  ];

  imports = [
    #../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
    ../../modules/shared/shell.nix
  ];

}
