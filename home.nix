{ config, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

  home.packages = [
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
