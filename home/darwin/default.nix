{ lib, pkgs, vdh-cli, voicevox-tts, repoPath ? null, userName, homeDirectory, ... }:

let
  customed-url-schema-iina = import ../../packages/custom-url-schema-iina/default.nix { inherit (pkgs) stdenv; };
in
{
  programs.home-manager.enable = true;
  home = {
    username = userName;
    homeDirectory = homeDirectory;
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
      customed-url-schema-iina
      discord
      iina
      slack
      vdh-cli.packages.aarch64-darwin.default
      voicevox-tts.packages.aarch64-darwin.default
      vscode
      zoom-us
    ];

  imports = [
    #../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/git.nix
    ../../modules/shared/llm.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/nix.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
  ];


}
