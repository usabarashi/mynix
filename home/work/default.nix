{ lib, pkgs, ... }:

let
  cyberduck = (import
    (builtins.fetchGit {
      # See: https://www.nixhub.io/packages/cyberduck
      name = "unstable-9.1.2.42722";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "eaeed9530c76ce5f1d2d8232e08bec5e26f18ec1";
    })
    { system = "aarch64-darwin"; }).cyberduck;

  dbeaver = (import
    (builtins.fetchGit {
      # See: https://www.nixhub.io/packages/dbeaver
      name = "unstable-22.2.2";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "3281bec7174f679eabf584591e75979a258d8c40";
    })
    { system = "aarch64-darwin"; }).dbeaver;
in
{
  programs.home-manager.enable = true;
  home = {
    username = "motoki_kamimura";
    homeDirectory = "/Users/motoki_kamimura";
    stateVersion = "24.05";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "vscode-insiders"
  ];

  home.packages = with pkgs; [
    cyberduck
    dbeaver
    scala-cli
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
