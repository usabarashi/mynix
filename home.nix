{ config, lib, pkgs, stdenv, ... }:

let
  helloWorld = import ./packages/helloworld/default.nix;
in
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
    helloWorld
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
