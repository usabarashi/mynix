{ lib }:

{
  # Detect system architecture from environment variables
  detectSystem =
    { systemType, arch }:
    if systemType == "Darwin" then
      (if arch == "arm64" then "aarch64-darwin" else "x86_64-darwin")
    else
      (if arch == "aarch64" then "aarch64-linux" else "x86_64-linux");
}
