{ lib, pkgs, repoPath ? null, userName, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = "25.05";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "vscode"
    "vscode-insiders"
    "vscode-extension-claude-code"
  ];

  home.packages = with pkgs; [
    cyberduck
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
