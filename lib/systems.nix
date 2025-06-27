{ lib }:

{
  # Detect system architecture from environment variables (Darwin only)
  detectSystem =
    { systemType, arch }:
    if systemType == "Darwin" || systemType == "" then
      (if arch == "arm64" || arch == "" then "aarch64-darwin" else "x86_64-darwin")
    else
      builtins.throw "This flake only supports Darwin systems. Detected system: ${systemType}";
}
