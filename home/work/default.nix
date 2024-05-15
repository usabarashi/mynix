{ lib, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "motoki_kamimura";
    homeDirectory = "/Users/motoki_kamimura";
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    cyberduck
    dbeaver
  ];

  imports = [
    ../../modules/shared/container.nix
    ../../modules/darwin/karabiner.nix
    ../../modules/shared/git.nix
    ../../modules/shared/neovim.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/vscode.nix
    ../../modules/shared/shell.nix
  ];

}
