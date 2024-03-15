# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
{ config, pkgs, ... }:

let
  extraConfigPath = "~/.ssh/extra_config";
in
{
  programs.ssh = {
    enable = true;

    includes = [
      extraConfigPath
    ];

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github_rsa";
        identitiesOnly = true;
        user = "usabarashi";
      };
    };

  };
}
