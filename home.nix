{ config, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

  imports = [
    ./git.nix
    ./karabiner.nix
    ./ssh.nix
  ];

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
