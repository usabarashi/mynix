{ config, lib, pkgs, ... }:

{
  home.username = "gen";
  home.homeDirectory = "/Users/gen";
  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];

  imports = [
    ./git.nix
    ./karabiner.nix
    ./ssh.nix
    ./vscode.nix
  ];

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}