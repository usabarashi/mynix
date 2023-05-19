# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix 
{ config, pkgs, ... }:

{
  programs.vscode.enable = true;
  programs.vscode.enableUpdateCheck = false;

  # /Users/USER_NAME/Library/Application Support/Code/User/settings.json
  programs.vscode.userSettings = {
    "editor.tabSize" = 4;
    "[nix]"."editor.tabSize" = 2;
  };

  # /Users/USER_NAME/.vscode/extensions/extensions.json 
  programs.vscode.extensions = (with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    ms-azuretools.vscode-docker
    streetsidesoftware.code-spell-checker
    vscodevim.vim
  ]);

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}