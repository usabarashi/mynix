{ fetchurl, lib, stdenv, p7zip }:

let
  minerVersion = "0.10.2_1450";
in
stdenv.mkDerivation rec {
  pname = "OrbStack";
  version = "0.10.2";

  src = fetchurl {
    url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v${minerVersion}_arm64.dmg";
    sha256 = "sha256-wBZ2dI9RyC5NXtlJJaxV6hebBLsfYGa6OcVq3eBfPd8=";
  };

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    echo "File to unpack: $src"
    if ! [[ "$src" =~ \.dmg$ ]]; then return 1; fi
    mnt=$(mktemp -d -t ci-XXXXXXXXXX)

    function finish {
      echo "Detaching $mnt"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    trap finish EXIT

    echo "Attaching $mnt"
    /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

    echo "What's in the mount dir"?
    ls -la $mnt/

    echo "Copying contents"
    shopt -s extglob
    DEST="$PWD"
    (cd "$mnt"; cp -a !(Applications) "$DEST/")
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r ./$pname.app $out/Applications/$pname.app
  '';

  meta = with lib; {
    homepage = "https://orbstack.dev/";
    description = "Seamless and efficient Docker and Linux on your Mac.";
    # see: https://docs.orbstack.dev/legal/terms#_1-license-grant
    license = licenses.free;
    platforms = platforms.darwin;
  };
}
