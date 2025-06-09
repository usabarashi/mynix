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
    "claude-code"
    "discord"
    "slack"
    "vscode"
    "vscode-insiders"
    "vscode-extension-claude-code"
    "zoom"
  ];


  home.packages = with pkgs;
    [
      claude-code
      customed-url-schema-iina
      discord
      iina
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
