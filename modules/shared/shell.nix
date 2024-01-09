{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    direnv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    #nix-direnv.enableFlakes = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    envExtra = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix
    '';

    syntaxHighlighting.enable = true;
  };
}
