{ config, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

  imports = [
    ./git.nix
    ./karabiner.nix
  ];

  home.file = {
    ".ssh/config".source = ./config/ssh/config;
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
