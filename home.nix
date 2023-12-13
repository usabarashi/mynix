{ config, lib, pkgs, stdenv, ... }:

{
  #home.username = builtins.getEnv "USER";
  #home.homeDirectory = "/Users/gen";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "slack"
    "vscode"
    "zoom"
  ];

  home.packages = with pkgs; [
    calibre
    discord
    iina
    slack
    zoom-us
  ];

  imports = [
    ./container.nix
    ./git.nix
    ./karabiner.nix
    ./neovim.nix
    ./ssh.nix
    ./vscode.nix
    ./zsh.nix
  ];

  home.sessionVariables = { };

}
