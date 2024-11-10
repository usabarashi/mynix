# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, lib, ... }:
let
  vscode-from-devshell = pkgs.stdenv.mkDerivation {
    pname = "vscode-from-devshell";
    version = "1.0.0";

    src = ./.;

    buildInputs = [ ];

    installPhase = ''
      mkdir -p $out/bin
      echo '#!/bin/sh' > $out/bin/code-from-devshell
      echo 'original_dir=$(pwd)' >> $out/bin/code-from-devshell
      echo 'cd "$1"' >> $out/bin/code-from-devshell
      echo 'shift' >> $out/bin/code-from-devshell
      echo 'code . "$@"' >> $out/bin/code-from-devshell
      echo 'cd "$original_dir"' >> $out/bin/code-from-devshell
      chmod +x $out/bin/code-from-devshell
    '';

    meta = with lib; {
      description = "vscode wrapper for devshell";
      homepage = "https://github.com/usabarashi/mynix";
      license = licenses.mit;
    };
  };
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];

  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
    vscode
    vscode-from-devshell
  ];

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
