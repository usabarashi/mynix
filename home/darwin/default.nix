{ lib, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "gen";
    homeDirectory = "/Users/gen";
    stateVersion = "23.11";
    sessionVariables = { };
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
    slack
    zoom-us
  ];

  imports = [
    #../../modules/container.nix
    ../../modules/git.nix
    #../../modules/karabiner.nix
    ../../modules/neovim.nix
    ../../modules/ssh.nix
    ../../modules/vscode.nix
    ../../modules/zsh.nix
  ];

}
