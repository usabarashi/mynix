# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rnix-lsp
  ];

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    # /Users/USER_NAME/Library/Application Support/Code/User/settings.json
    userSettings = {
      "editor" = {
        "formatOnSave" = true;
        "tabSize" = 4;
      };
      "[nix]"."editor.tabSize" = 2;

      "files" = {
        "insertFinalNewline" = true;
        "trimFinalNewlines" = true;
        "trimTrailingWhitespace" = true;
      };

      "extensions.ignoreRecommendations" = false;
      "nix" = {
        "enableLanguageServer" = true;
      };
    };

    # /Users/USER_NAME/.vscode/extensions/extensions.json
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vscode-extensions/<extension-name>/<version>/vspackage
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.86.82";
        sha256 = "sha256-isaqjrAmu/08gnNKQPeMV4Xc8u0Hx8gB2c78WE54kYQ=";
      }
      {
        name = "vscode-remote-extensionpack";
        publisher = "ms-vscode-remote";
        version = "0.24.0";
        sha256 = "sha256-6v4JWpyMxqTDIjEOL3w25bdTN+3VPFH7HdaSbgIlCmo";
      }
    ];
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
