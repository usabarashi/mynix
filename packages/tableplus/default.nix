# See: https://github.com/Homebrew/homebrew-cask/blob/master/Casks/t/tableplus.rb
{ fetchurl, lib, stdenv, p7zip }:

stdenv.mkDerivation rec {
  pname = "tableplus";
  buildVersion = "550";
  name = "${pname}-${buildVersion}";

  src = fetchurl {
    url = "https://files.tableplus.com/macos/${buildVersion}/TablePlus.dmg";
    sha256 = "ef1343a9f281fc24d071af976239f4225c623e4db731957508cd7b175fc6ff28";
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
    homepage = "https://tableplus.com/";
    description = "Database management made easy";
    license = licenses.free;
    platforms = platforms.darwin;
  };
}
