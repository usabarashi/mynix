{ lib, pkgs, repoPath ? null, userName, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = "25.05";
  };


  home.packages = with pkgs; [
    cyberduck
    
    flakeInputs.voicevox-cli
  ];


  imports = [
    ../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/llm.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
    ../../modules/shared/shell.nix
  ];


}
