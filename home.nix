{ config, lib, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

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
    ./colima.nix
    ./docker.nix
    ./git.nix
    ./karabiner.nix
    ./ssh.nix
    ./vscode.nix
  ];

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}