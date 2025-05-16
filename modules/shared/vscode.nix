# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, lib, ... }: # Added workspaceSettingsJsonPathForVSCode argument

let
  inherit (pkgs.lib.trivial) importJSON importTOML mergeAttrs;

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
  home.packages = with pkgs; [ vscode-from-devshell ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
  };

  programs.vscode.profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = importJSON ../../.vscode/settings.json;

    keybindings = [ ];

    # https://marketplace.visualstudio.com/vscode
    # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<extension-name>/<version>/vspackage
    # https://www.vsixhub.com/
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace ([
      ###############
      # Base Settings

      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "4.0.42";
        sha256 = "Ze9Hqa09jUwepOeiLeFVoYoR5JbzJKFRxydti/S10kI=";
      }
      {
        name = "errorlens";
        publisher = "usernamehw";
        version = "3.24.0";
        sha256 = "r5xXR4rDbP+2bk66yqPoLod8IZXFrntcKHuWbAiFWwE=";
      }
      {
        name = "geminicodeassist";
        publisher = "google";
        version = "2.32.0";
        sha256 = "sha256-FRf1DdcDvlxds0RPM8f7kV7cGomJVVM8gx3Mg7O8ALQ=";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "2025.4.905";
        sha256 = "sha256-MieWkv/OCEAvjnpN/AccDEVcAIAWSbl+PBMttvg4E2s=";
      }
      {
        name = "markdown-mermaid";
        publisher = "bierner";
        version = "1.27.0";
        sha256 = "09w/k1LlGYtyWWbVgoprJG/qB/zCuedF9Cu7kUXcNrE=";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.4.16";
        sha256 = "MdFDOg9uTUzYtRW2Kk4L8V3T/87MRDy1HyXY9ikqDFY=";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.408.0";
        sha256 = "k/c0Ylot3DUJ2UNZDozNmDwuaUAZgPWfuVT16h9eZZI=";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.120.2025040915";
        sha256 = "sha256-XW7BiUtqFH758I5DDRU2NPdESJC6RfTDAuUA4myY734=";
      }
      {
        name = "run-on-save";
        publisher = "pucelle";
        version = "1.10.2";
        sha256 = "sha256-CRmahf1fbB/5X5f20yUmQXx6D4RghXYDXxfhBPrNUdc=";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.29.0";
        sha256 = "J3V8SZJZ2LSL8QfdoOtHI1ZDmGDVerTRYP4NZU17SeQ=";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.29.4";
        sha256 = "j2ACz2Ww5hddoDLHGdxnuQIqerP5ogZ80/wS+Aa5Gdo=";
      }
      {
        name = "vscode-drawio";
        publisher = "hediet";
        version = "1.9.250226013";
        sha256 = "i4r6tZtOdt1ZzTeITUprtOQl6RncKMhnd4m+BqYqgBk=";
      }
      {
        name = "vscode-github-actions";
        publisher = "GitHub";
        version = "0.27.1";
        sha256 = "sha256-mHKaWXSyDmsdQVzMqJI6ctNUwE/6bs1ZyeAEWKg9CV8=";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.107.2025032704";
        sha256 = "dLg9GAQ9Gu3YZE4PH6UuH0aQitsZJGD4nHv3yqK6nTQ=";
      }

      ################
      # GitHub Copilot
      {
        name = "copilot";
        publisher = "github";
        version = "1.297.0";
        sha256 = "sha256-UVL0Yf8MSY7ETOxmEK+dljrOQL9ctUWVhbYdr0v00b0=";
      }
      {
        # https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-issues-with-github-copilot-chat#troubleshooting-issues-caused-by-version-incompatibility
        # > every new version of Copilot Chat is only compatible with the latest release of Visual Studio Code.
        # > This means that if you are using an older version of Visual Studio Code, you will not be able to use the latest Copilot Chat.
        name = "copilot-chat";
        publisher = "github";
        version = "0.26.2";
        sha256 = "sha256-TgfzaX+CPUYST6+JG4RGcUl3e8G2lev3iJOXDPNpBuQ=";
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

      ######################
      # Programming Language

      # Alloy
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
      # Elm
      {
        name = "elm-ls-vscode";
        publisher = "elmtooling";
        version = "2.8.0";
        sha256 = "sha256-81tHgNjYc0LJjsgsQfo5xyh20k/i3PKcgYp9GZTvwfs=";
      }
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
      # HashiCorp Configuration Language
      {
        name = "terraform";
        publisher = "HashiCorp";
        version = "2.34.2025012311";
        sha256 = "SmADVhgysDDvmI2/FZHoNWfgSrcxQfJTJj4ZgxOxjhc=";
      }
      # Python
      {
        name = "python";
        publisher = "ms-python";
        version = "2025.4.0";
        sha256 = "sha256-/yQbmZTnkks1gvMItEApRzfk8Lczjq+JC5rnyJxr6fo=";
      }
      # Scala
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.50.1";
        sha256 = "sha256-gOC3YLOLtb3+sTeSoLfZrOsLjNtLOyR2Nk7a7KLhDiU=";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.5.9";
        sha256 = "zgCqKwnP7Fm655FPUkD5GL+/goaplST8507X890Tnhc=";
      }

      ############
      # Data Store

      {
        name = "mysql-shell-for-vs-code";
        publisher = "oracle";
        version = "1.19.3";
        sha256 = "t/Z4vOsR2GseFQj5N6VzYiAj0AJiwC1mF2N+LdTwUcM=";
      }
    ]);
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
