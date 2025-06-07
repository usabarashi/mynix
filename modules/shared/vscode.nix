# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, lib, ... }:

let
  inherit (pkgs.lib.trivial) importJSON mergeAttrs;
  inherit (pkgs.vscode-utils) extensionFromVscodeMarketplace extensionsFromVscodeMarketplace;

  claudeCodeExtension = pkgs.claude-code-vscode-extension;

  nixpkgsExtensions = with pkgs.vscode-extensions; [
    # Basic extensions
    streetsidesoftware.code-spell-checker
    usernamehw.errorlens
    eamodio.gitlens
    vscodevim.vim
    github.vscode-github-actions
    github.vscode-pull-request-github

    # Remote
    ms-azuretools.vscode-docker

    # Programming Languages
    elmtooling.elm-ls-vscode
    hashicorp.terraform
    jnoortheen.nix-ide
    ms-python.python
    rust-lang.rust-analyzer
    scalameta.metals
    scala-lang.scala
  ];

  # Extensions not available in nixpkgs - from marketplace
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # File format
    {
      name = "markdown-mermaid";
      publisher = "bierner";
      version = "1.28.0";
      sha256 = "sha256-09w/k1LlGYtyWWbVgoprJG/qB/zCuedF9Cu7kUXcNrE=";
    }
    {
      name = "vscode-drawio";
      publisher = "hediet";
      version = "1.9.0";
      sha256 = "sha256-i4r6tZtOdt1ZzTeITUprtOQl6RncKMhnd4m+BqYqgBk=";
    }

    # Programming Languages - Alloy
    {
      name = "alloy";
      publisher = "ArashSahebolamri";
      version = "0.7.1";
      sha256 = "sha256-svHFOCEDZHSLKzLUU2ojDVkbLTJ7hJ75znWuBV5GFQM=";
    }
    {
      name = "alloy-vscode";
      publisher = "DongyuZhao";
      version = "0.1.6";
      sha256 = "sha256-wYMxjMY7colRKWb0qDpMC07+hYhIxh5KcibO43yczPs=";
    }
    # Programming Languages - Elm
    {
      name = "vscode-test-explorer";
      publisher = "hbenl";
      version = "2.22.1";
      sha256 = "sha256-+vW/ZpOQXI7rDUAdWfNOb2sAGQQEolXjSMl2tc/Of8M=";
    }
    {
      name = "test-adapter-converter";
      publisher = "ms-vscode";
      version = "0.2.1";
      sha256 = "sha256-gyyl379atZLgtabbeo26xspdPjLvNud3cZ6kEmAbAjU=";
    }

    # Remote
    {
      name = "mysql-shell-for-vs-code";
      publisher = "oracle";
      version = "1.19.3";
      sha256 = "sha256-t/Z4vOsR2GseFQj5N6VzYiAj0AJiwC1mF2N+LdTwUcM=";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.408.0";
      sha256 = "sha256-k/c0Ylot3DUJ2UNZDozNmDwuaUAZgPWfuVT16h9eZZI=";
    }
    {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.120.0";
      sha256 = "sha256-XW7BiUtqFH758I5DDRU2NPdESJC6RfTDAuUA4myY734=";
    }

    # LLM - GitHub Copilot
    {
      name = "copilot";
      publisher = "github";
      version = "1.297.0";
      sha256 = "sha256-UVL0Yf8MSY7ETOxmEK+dljrOQL9ctUWVhbYdr0v00b0=";
    }
    {
      name = "copilot-chat";
      publisher = "github";
      version = "0.27.0";
      sha256 = "sha256-i7KKW+aM8P1nrgnLZssgAlKm1kaQyeh285EnoN9Bwps=";
    }
    {
      name = "vscode-speech";
      publisher = "ms-vscode";
      version = "0.12.1";
      sha256 = "sha256-fxmaPI7uq7DQlzgJc8RcZzHDOwMuodSCf9TkLU9+/+k=";
    }
    {
      name = "vscode-speech-language-pack-ja-jp";
      publisher = "ms-vscode";
      version = "0.5.0";
      sha256 = "sha256-gbesiqyKWPlEPDyAmTgDSbMN9rWRkq1Trsih0gLgPr0=";
    }
    # LLM - Google Gemini
    {
      name = "geminicodeassist";
      publisher = "google";
      version = "2.35.0";
      sha256 = "sha256-4l1YKwYPkSShEJVoN+4m8SUQXLC5V3ioPNAKDuTVDsk=";
    }


  ];

  # Combine all extensions
  extensions = nixpkgsExtensions ++ marketplaceExtensions ++ [ claudeCodeExtension ];

  # See: https://nixos.wiki/wiki/Visual_Studio_Code
  vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=insider&os=darwin-universal";
      sha256 = "sha256:05i1mlzhbpjz7397rrdyqw9v9gcihvxqzj3hf0al6c770dmswgfy";
    });
    version = "latest";

    #buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
  });

  vscode-from-devshell = pkgs.writeShellScriptBin "codefd" ''
    #!/bin/sh

    # codefd - Code From DevShell
    # This script launches VS Code while preserving the environment variables from the current devShell environment.
    # When working in a Nix devShell, launching VS Code normally might not inherit all the necessary environment variables.
    # This script allows you to pass the devShell environment variables directly to VS Code.
    #
    # Usage: codefd <project_directory> [VSCode options]
    # Example: codefd ~/projects/my-nix-project

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
    nixpkgs-fmt
    vscode-from-devshell
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode;
  };

  programs.vscode.profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = lib.recursiveUpdate (importJSON ../../.vscode/settings.json) {
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nil}/bin/nil";
        serverSettings.nil = {
          diagnostics = { ignored = [ "unused_binding" "unused_with" ]; };
          formatting = { command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ]; };
        };
      };
    };

    keybindings = [ ];

    # https://marketplace.visualstudio.com/vscode
    # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<extension-name>/<version>/vspackage
    # https://www.vsixhub.com/
    # Extensions are now automatically loaded from config/vscode/extensions.toml
    # No need to specify versions or hashes manually
    extensions = extensions;
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
