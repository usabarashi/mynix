{ lib, pkgs, repoPath ? null, userName, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = "24.05";
  };



  home.packages = with pkgs; [
    discord
    iina
    slack
    vscode
    zoom-us
    
    flakeInputs.vdh-cli
    flakeInputs.voicevox-cli
    customPackages.custom-url-schema-iina
  ];


  imports = [
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
