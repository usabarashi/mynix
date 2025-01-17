{ pkgs, ... }:
let
  os =
    if pkgs.stdenv.isDarwin then "darwin"
    else throw "Unsupported architecture";
  arch =
    if pkgs.stdenv.isAarch64 then "aarch64"
    else throw "Unsupported architecture";

  version = "2.32.4";
  sha256 =
    if os == "darwin" && arch == "aarch64" then
      "sha256-3DCwJ2wLpFhX7vAhtnfU+yu/E7z4CfmbaR25USvKR8w="
    else
      throw "Unsupported combination of OS and architecture";

  src = pkgs.fetchurl {
    url = "https://github.com/docker/compose/releases/download/v${version}/docker-compose-${os}-${arch}";
    sha256 = sha256;
  };
in
pkgs.stdenv.mkDerivation {
  pname = "docker-compose";
  version = version;

  src = src;

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/cli-plugins
    cp ${src}  $out/cli-plugins/docker-compose
    chmod +x $out/cli-plugins/docker-compose
  '';
}
