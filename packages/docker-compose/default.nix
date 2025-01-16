{ pkgs, ... }:
let
  os =
    if pkgs.stdenv.isDarwin then "darwin"
    else throw "Unsupported architecture";
  arch =
    if pkgs.stdenv.isAarch64 then "aarch64"
    else throw "Unsupported architecture";

  version = "2.23.3";
  sha256 =
    if os == "darwin" && arch == "aarch64" then "sha256-chLZPy/92V+JKc+Jq5X6VRiV7xcHcGXKuwD2+FYziIs="
    else throw "Unsupported combination of OS and architecture";

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
    mkdir -p $out/bin
    cp ${src} $out/bin/docker-compose
    chmod +x $out/bin/docker-compose
  '';
}
