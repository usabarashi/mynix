with import <nixpkgs> { };
stdenv.mkDerivation rec {
  pname = "docker-compose";
  version = "1.0.0";

  src = ./.;

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp docker-compose.sh $out/bin/docker-compose
    chmod +x $out/bin/docker-compose
  '';

  meta = with lib; {
    description = "Sample package";
    homepage = "https://github.com/usabarashi/home-manager";
    license = licenses.mit;
  };
}
