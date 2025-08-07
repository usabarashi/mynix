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
    editorCore
    versionControl
    fileFormats
    remoteDevelopment
    programmingLanguages
    aiAssistants
    ;

  editorCoreExtensions = collectExtensions editorCore;
  versionControlExtensions = collectExtensions versionControl;
  fileFormatsExtensions = collectExtensions fileFormats;
  remoteDevelopmentExtensions = collectExtensions remoteDevelopment;
  programmingLanguageExtensions = collectNestedExtensions programmingLanguages;
  aiAssistantExtensions = collectNestedExtensions aiAssistants;

  allExtensions =
    editorCoreExtensions
    ++ versionControlExtensions
    ++ fileFormatsExtensions
    ++ remoteDevelopmentExtensions
    ++ programmingLanguageExtensions
    ++ aiAssistantExtensions;

  vscode-from-devshell = pkgs.writeShellScriptBin "codefd" ''
    #!/bin/sh
    # codefd - Code From DevShell
    # Launches VS Code while preserving devShell environment variables
    # Usage: codefd <project_directory> [VSCode options]

    if [ ! -d "$1" ]; then
      echo "Error: $1 is not a directory" >&2
      echo "Usage: codefd <project_directory> [VSCode options]" >&2
      exit 1
    fi

    cd "$1"
    shift
    code . "$@"
  '';
in
{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
    vscode-from-devshell
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode;
    profiles.default = {
      extensions = allExtensions;
    };
  };

  home.file."Library/Application Support/Code/User/settings.json" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/Code/User/settings.json";
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
