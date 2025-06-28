# See: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{
  config,
  pkgs,
  lib,
  repoPath,
  ...
}:

let
  inherit (pkgs.vscode-utils) extensionFromVscodeMarketplace extensionsFromVscodeMarketplace;

  alloyJar = pkgs.fetchurl {
    url = "https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v6.2.0/org.alloytools.alloy.dist.jar";
    sha256 = "13dpxl0ri6ldcaaa60n75lj8ls3fmghw8d8lqv3xzglkpjsir33b";
  };
  alloyExtension =
    (pkgs.vscode-utils.extensionFromVscodeMarketplace {
      name = "alloy";
      publisher = "ArashSahebolamri";
      version = "0.7.1";
      sha256 = "sha256-svHFOCEDZHSLKzLUU2ojDVkbLTJ7hJ75znWuBV5GFQM=";
    }).overrideAttrs
      (oldAttrs: {
        postPatch =
          (oldAttrs.postPatch or "")
          + ''
            if [ -f org.alloytools.alloy.dist.jar ]; then
              cp ${alloyJar} org.alloytools.alloy.dist.jar
            fi
          '';
      });

  claudeCodeExtension = pkgs.vscode-utils.buildVscodeExtension {
    pname = "claude-code";
    version = pkgs.claude-code.version;
    src = pkgs.runCommand "claude-code.zip" { } ''
      cp "${pkgs.claude-code}/lib/node_modules/@anthropic-ai/claude-code/vendor/claude-code.vsix" $out
    '';
    vscodeExtUniqueId = "Anthropic.claude-code";
    vscodeExtPublisher = "Anthropic";
    vscodeExtName = "claude-code";

    meta = {
      description = "Claude Code VS Code Extension";
      homepage = "https://claude.ai/code";
      license = pkgs.lib.licenses.unfree;
      platforms = pkgs.lib.platforms.all;
    };
  };

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
      name = "alloy-vscode";
      publisher = "DongyuZhao";
      version = "0.1.1";
      sha256 = "sha256-KhotnrJdW6i0X+sEbzfxSfVQ8CYQrWt2wpW5igZkCn8=";
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
      sha256 = "sha256-D9YmLKGDtIb2wGfLNRbczqL4fzLASbZC/563ewzqGV0=";
    }

    # LLM - GitHub Copilot
    {
      name = "copilot";
      publisher = "github";
      version = "1.335.0";
      sha256 = "sha256-GqUegNF1XIpEaQy+0v+TTyIR+EPaeXKVpH4QnvxXt9c=";
    }
    {
      name = "copilot-chat";
      publisher = "github";
      version = "0.28.0";
      sha256 = "sha256-Pc04vtCSPlXALPnFtgQcEVa+exzfkYqFh/b8K3bUBJg=";
    }
    {
      name = "vscode-speech";
      publisher = "ms-vscode";
      version = "0.16.0";
      sha256 = "sha256-JhZWNlGXljsjmT3/xDi9Z7I4a2vsi/9EkWYbnlteE98=";
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
      version = "2.38.0";
      sha256 = "sha256-B9YgvSAjvVc0CMt4JPkj0BqJdDG2Ie+DXC7Mv4O/ia8=";
    }
  ];

  # Combine all extensions
  extensions =
    nixpkgsExtensions
    ++ marketplaceExtensions
    ++ [
      alloyExtension
      claudeCodeExtension
    ];

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
  };

  programs.vscode.profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # userSettings = { }; # Settings managed by symlinked file
    keybindings = [ ];
    extensions = extensions;
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
