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
      bierner.markdown-mermaid
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vscode-extensions/<extension-name>/<version>/vspackage
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.292.0";
        sha256 = "sha256-U1ZuxfoUBWdnOy+t4Zp7B5jyvGt89xsufrqnX09gm4U=";
      }
      {
        name = "vsliveshare";
        publisher = "MS-vsliveshare";
        version = "1.0.5864";
        sha256 = "sha256-UdI9iRvI/BaZj8ihFBCTFJGLZXxS3CtmoDw8JBPbzLY=";
      }
    ];
  };
  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
