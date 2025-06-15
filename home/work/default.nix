{ lib, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "motoki_kamimura";
    homeDirectory = "/Users/motoki_kamimura";
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
    ../../modules/shared/aider.nix
    ../../modules/shared/llm.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
    ../../modules/shared/shell.nix
  ];


}
