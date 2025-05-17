{ lib, pkgs, ... }:

let
  customed-url-schema-iina = import ../../packages/custom-url-schema-iina/default.nix { inherit (pkgs) stdenv; };
in
{
  programs.home-manager.enable = true;
  home = {
    username = "gen";
    homeDirectory = "/Users/gen";
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "slack"
    "vscode"
    "vscode-insiders"
    "zoom"
  ];

  home.packages = with pkgs;
    [
      discord
      iina
      customed-url-schema-iina
      scala-cli
      slack
      zoom-us
    ];

  imports = [
    #../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
  ];

}
