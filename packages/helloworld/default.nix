with import <nixpkgs> { };
stdenv.mkDerivation rec {
  pname = "Hello-World";
  version = "1.0.0";

  src = ./.;

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp helloworld.sh $out/bin/helloworld
    chmod +x $out/bin/helloworld
  '';

  meta = with lib; {
    description = "Sample package";
    homepage = "https://github.com/usabarashi/home-manager";
    license = licenses.mit;
  };
}
