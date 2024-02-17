# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "usabarashi";
    userEmail = "19676305+usabarashi@users.noreply.github.com";
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
