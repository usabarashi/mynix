# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/cl/claude-code/package.nix
final: prev:
let
  claudeCodeVersion = "1.0.11";
in
{
  overlay-claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = claudeCodeVersion;

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-y5+3rjHqfNgY1f/fIO+8/ZMd4NfI2C6zkMtPqP8ZJVM=";
    };
  });

  claude-code-vscode-extension = prev.vscode-utils.buildVscodeExtension {
    pname = "claude-code";
    version = claudeCodeVersion;
    src = prev.runCommand "claude-code.zip" { } ''
      cp "${final.overlay-claude-code}/lib/node_modules/@anthropic-ai/claude-code/vendor/claude-code.vsix" $out
    '';
    vscodeExtUniqueId = "Anthropic.claude-code";
    vscodeExtPublisher = "Anthropic";
    vscodeExtName = "claude-code";

    meta = {
      description = "Claude Code VS Code Extension";
      homepage = "https://claude.ai/code";
      license = prev.lib.licenses.unfree;
      platforms = prev.lib.platforms.all;
    };
  };
}
