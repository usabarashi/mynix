# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github_rsa";
        identitiesOnly = true;
        user = "usabarashi";
      };
    };

  };
}
