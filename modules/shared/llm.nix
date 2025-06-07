# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/cl/claude-code/package.nix
final: prev: {
  overlay-claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
    version = "1.0.11";

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-y5+3rjHqfNgY1f/fIO+8/ZMd4NfI2C6zkMtPqP8ZJVM=";
    };
  });
}
