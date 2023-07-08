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

      "[json]" = {
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
      };

      "[nix]" = {
        "editor.tabSize" = 2;
      };
      "nix"."enableLanguageServer" = true;

      "[shellscript]" = {
        "editor.tabSize" = 4;
      };

      "[yaml]" = {
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
      };

      "files" = {
        "insertFinalNewline" = true;
        "trimFinalNewlines" = true;
        "trimTrailingWhitespace" = true;
      };

      "extensions.ignoreRecommendations" = false;
    };

    # /Users/USER_NAME/.vscode/extensions/extensions.json
    extensions = with pkgs.vscode-extensions; [
      bierner.markdown-mermaid
      foxundermoon.shell-format
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
      timonwong.shellcheck
      usernamehw.errorlens
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
        name = "vscode-drawio";
        publisher = "hediet";
        version = "1.6.6";
        sha256 = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.68.0";
        sha256 = "sha256-mESJ43tsUhYcj3wX8quIZGVo8ecdThueL9rlxRpYCX8=";
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
