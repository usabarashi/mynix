{
  lib,
  stdenv,
  makeWrapper,
  gemini-cli,
}:

stdenv.mkDerivation {
  pname = "gemini-cli-sandboxed";
  version = gemini-cli.version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gemini-cli ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${gemini-cli}/bin/gemini $out/bin/gemini \
      --add-flags "--sandbox"
  '';

  meta = with lib; {
    description = "AI agent that brings the power of Gemini directly into your terminal (sandboxed stub version)";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.usabarashi ];
  };
}
