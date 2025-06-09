{ pkgs }:

# Since marketplace extension has CRLF issues, let's just use the original marketplace extension
# without JAR replacement for now, and provide instructions for manual upgrade
pkgs.vscode-utils.extensionFromVscodeMarketplace {
  name = "alloy";
  publisher = "ArashSahebolamri";
  version = "0.7.1";
  sha256 = "sha256-svHFOCEDZHSLKzLUU2ojDVkbLTJ7hJ75znWuBV5GFQM=";
}