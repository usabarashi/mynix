{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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

      # Add user tools to PATH
      export PATH=$HOME/bin:$PATH
    '';

    syntaxHighlighting.enable = true;
  };
}
