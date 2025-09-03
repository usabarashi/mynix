# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{
  config,
  pkgs,
  lib,
  repoPath,
  ...
}:

let
  extensionsConfig = import ./vscode-extensions.nix { inherit pkgs; };
  inherit (extensionsConfig) collectExtensions collectNestedExtensions;
  inherit (extensionsConfig)
    programmingLanguages
    aiAssistants
    ;

  programmingLanguageExtensions = collectNestedExtensions programmingLanguages;
  aiAssistantExtensions = collectNestedExtensions aiAssistants;

  allExtensions = programmingLanguageExtensions ++ aiAssistantExtensions;
in
{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };

  home.file."Library/Application Support/Code/User/settings.json" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/.vscode/settings.json";
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
