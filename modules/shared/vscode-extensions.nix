{ pkgs, ... }:

let
  inherit (pkgs.vscode-utils) extensionFromVscodeMarketplace extensionsFromVscodeMarketplace;

  editorCore = {
    nixpkgs = with pkgs.vscode-extensions; [
      streetsidesoftware.code-spell-checker
      usernamehw.errorlens
      vscodevim.vim
    ];
    marketplace = [
    ];
  };

  versionControl = {
    nixpkgs = with pkgs.vscode-extensions; [
      eamodio.gitlens
      github.vscode-github-actions
      github.vscode-pull-request-github
    ];
    marketplace = [
    ];
  };

  fileFormats = {
    nixpkgs = with pkgs.vscode-extensions; [
    ];
    marketplace = [
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
    ];
  };

  remoteDevelopment = {
    nixpkgs = with pkgs.vscode-extensions; [
      ms-azuretools.vscode-docker
    ];
    marketplace = [
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
    ];
  };

  programmingLanguages = {
    nix = {
      nixpkgs = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
      marketplace = [
      ];
    };

    python = {
      nixpkgs = with pkgs.vscode-extensions; [
        ms-python.python
      ];
      marketplace = [
      ];
    };

    rust = {
      nixpkgs = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      marketplace = [
      ];
    };

    scala = {
      nixpkgs = with pkgs.vscode-extensions; [
        scalameta.metals
        scala-lang.scala
      ];
      marketplace = [
      ];
    };

    elm = {
      nixpkgs = with pkgs.vscode-extensions; [
        elmtooling.elm-ls-vscode
      ];
      marketplace = [
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
      ];
    };

    terraform = {
      nixpkgs = with pkgs.vscode-extensions; [
        hashicorp.terraform
      ];
      marketplace = [
      ];
    };

    alloy = {
      nixpkgs = [
      ];
      marketplace = [
        {
          name = "alloy-vscode";
          publisher = "DongyuZhao";
          version = "0.1.1";
          sha256 = "sha256-KhotnrJdW6i0X+sEbzfxSfVQ8CYQrWt2wpW5igZkCn8=";
        }
      ];
      custom = [
        (
          let
            alloyJar = pkgs.fetchurl {
              url = "https://github.com/AlloyTools/org.alloytools.alloy/releases/download/v6.2.0/org.alloytools.alloy.dist.jar";
              sha256 = "13dpxl0ri6ldcaaa60n75lj8ls3fmghw8d8lqv3xzglkpjsir33b";
            };
          in
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
            })
        )
      ];
    };
  };

  aiAssistants = {
    githubCopilot = {
      nixpkgs = [
      ];
      marketplace = [
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
      ];
    };

    googleGemini = {
      nixpkgs = [
      ];
      marketplace = [
        {
          name = "geminicodeassist";
          publisher = "google";
          version = "2.38.0";
          sha256 = "sha256-B9YgvSAjvVc0CMt4JPkj0BqJdDG2Ie+DXC7Mv4O/ia8=";
        }
        {
          name = "gemini-cli-vscode-ide-companion";
          publisher = "google";
          version = "0.1.21";
          sha256 = "sha256-ZWQEhxO2e9h3K2UbA2uWLL5WbndybsHTmSbaLvr9vIU=";
        }
      ];
    };

    claude = {
      nixpkgs = [
      ];
      marketplace = [
      ];
      custom = [
        (pkgs.vscode-utils.buildVscodeExtension {
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
        })
        (
          let
            version = "0.1.4";
          in
          pkgs.vscode-utils.buildVscodeExtension {
            pname = "claude-code-usage-monitor";
            inherit version;
            src = pkgs.runCommand "claude-code-usage-monitor.zip" { } ''
              cp "${
                pkgs.fetchurl {
                  url = "https://github.com/usabarashi/vscode-extension-claude-code-usage-monitor/releases/download/v${version}/claude-code-usage-monitor-v${version}.vsix";
                  sha256 = "sha256-4Qayrcfzvgivfp1glkPOw0iUfMLDVXR74vZ5zcn/jes=";
                }
              }" $out
            '';
            vscodeExtUniqueId = "usabarashi.claude-code-usage-monitor";
            vscodeExtPublisher = "usabarashi";
            vscodeExtName = "claude-code-usage-monitor";

            meta = {
              description = "Claude Code Usage Monitor VS Code Extension";
              homepage = "https://github.com/usabarashi/vscode-extension-claude-code-usage-monitor";
              license = pkgs.lib.licenses.mit;
              platforms = pkgs.lib.platforms.all;
            };
          }
        )
      ];
    };
  };

  collectExtensions =
    group:
    let
      nixpkgs = group.nixpkgs or [ ];
      marketplace = group.marketplace or [ ];
      custom = group.custom or [ ];
    in
    nixpkgs
    ++ (if marketplace != [ ] then extensionsFromVscodeMarketplace marketplace else [ ])
    ++ custom;

  collectNestedExtensions =
    groups:
    builtins.concatLists (builtins.map (group: collectExtensions group) (builtins.attrValues groups));

in
{
  inherit
    editorCore
    versionControl
    fileFormats
    remoteDevelopment
    programmingLanguages
    aiAssistants
    collectExtensions
    collectNestedExtensions
    ;

  extensions =
    collectExtensions editorCore
    ++ collectExtensions versionControl
    ++ collectExtensions fileFormats
    ++ collectExtensions remoteDevelopment
    ++ collectNestedExtensions programmingLanguages
    ++ collectNestedExtensions aiAssistants;
}
