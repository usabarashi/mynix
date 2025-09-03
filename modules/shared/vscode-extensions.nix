{ pkgs, ... }:

let
  inherit (pkgs.vscode-utils) extensionFromVscodeMarketplace extensionsFromVscodeMarketplace;

  programmingLanguages = {
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
              postPatch = (oldAttrs.postPatch or "") + ''
                if [ -f org.alloytools.alloy.alloy.dist.jar ]; then
                  cp ${alloyJar} org.alloytools.alloy.dist.jar
                fi
              '';
            })
        )
      ];
    };
  };

  aiAssistants = {
    claude = {
      nixpkgs = [
      ];
      marketplace = [
      ];
      custom = [
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
    programmingLanguages
    aiAssistants
    collectExtensions
    collectNestedExtensions
    ;

  extensions = collectNestedExtensions programmingLanguages ++ collectNestedExtensions aiAssistants;
}
