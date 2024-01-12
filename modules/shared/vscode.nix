# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rnix-lsp
  ];

  programs.vscode = {
    enable = true;
    # Fixed to false because the contents of the Derivation result will be edited.
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
      arrterian.nix-env-selector
      bierner.markdown-mermaid
      foxundermoon.shell-format
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      scalameta.metals
      streetsidesoftware.code-spell-checker
      timonwong.shellcheck
      usernamehw.errorlens
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vscode-extensions/<extension-name>/<version>/vspackage
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.110.389";
        sha256 = "sha256-Lm3m70gRZXAwQF8R/tRH/0VL5mkhFqI744MEX1MCuAY=";
      }
      {
        name = "copilot-chat";
        publisher = "GitHub";
        version = "0.7.0";
        sha256 = "sha256-U0DkTiJtNsGqifGuid1ZpersiHA0gKVZArxDFc5VVKI=";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.292.0";
        sha256 = "sha256-U1ZuxfoUBWdnOy+t4Zp7B5jyvGt89xsufrqnX09gm4U=";
      }
      {
        name = "terraform";
        publisher = "HashiCorp";
        version = "2.29.1";
        sha256 = "sha256-0XC0j0DQbRnu5k8HBgJSoYb7noj2jxFtgPvGazx0uyI=";
      }
      {
        name = "vscode-drawio";
        publisher = "hediet";
        version = "1.6.6";
        sha256 = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
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
