{
  lib,
  stdenv,
  makeWrapper,
  gemini-cli,
}:

stdenv.mkDerivation {
  pname = gemini-cli.pname;
  version = gemini-cli.version;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${gemini-cli}/bin/gemini $out/bin/gemini \
      --add-flags "--sandbox"
  '';

  meta = gemini-cli.meta;
}
