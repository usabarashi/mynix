{
  lib,
  pkgs,
  repoPath ? null,
  userName,
  homeDirectory,
  flakeInputs,
  ...
}:

{
  programs.home-manager.enable = true;
  home = {
    username = userName;
    homeDirectory = homeDirectory;
    stateVersion = "25.05";
  };

  home.packages =
    with pkgs;
    [
      discord
      iina
      slack
      vscode
      zoom-us
    ]
    ++ [
      customPackages.custom-url-schema-iina
    ]
    ++ [
      flakeInputs.vdh-cli
      flakeInputs.voicevox-cli
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
