{ config, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

  imports = [
    ./karabiner.nix
  ];

  home.packages = [
    pkgs.git
  ];

  home.file = {
    ".config/git/config".source = ./config/git/config;
    ".ssh/config".source = ./config/ssh/config;
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
