# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "usabarashi";
    userEmail = "usabarashi@mac.com";
    extraConfig = {
      core.autocrlf = "input";
      credential.helper = "osxkeychain";
    };
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
    ];
  };
}
