{ config, lib, pkgs, stdenv, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "23.05";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "slack"
    "vscode"
    "zoom"
  ];

  home.packages = with pkgs; [
    discord
    slack
    zoom-us
  ];

  imports = [
    ./container.nix
    ./git.nix
    ./karabiner.nix
    ./ssh.nix
    ./vscode.nix
    ./zsh.nix
  ];

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
