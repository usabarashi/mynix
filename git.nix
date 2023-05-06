# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    iniContent = {
      user = {
        name = "usabarashi";
        email = "usabarashi@mac.com";
      };
      core = {
        autocrlf = "input";
      };
    };
  };
}
