{ lib
, stdenv
, fetchFromGitHub
, nodejs_24
, makeWrapper
}:

stdenv.mkDerivation {
  pname = "kibela-mcp-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "kibela";
    repo = "kibela-mcp-server";
    rev = "v0.1.1";
    hash = "sha256-j4oJW9qe88jyX7xYKYTgjgsfdFyeVgQYE6x0jesQNxs=";
  };

  nativeBuildInputs = [ nodejs_24 makeWrapper ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    export NODE_TLS_REJECT_UNAUTHORIZED=0
    export npm_config_strict_ssl=false

    # Install all dependencies (including dev deps for build)
    npm install --no-audit --no-fund

    # Build the project (creates bin/cli.mjs)
    npm run build

    # Remove dev dependencies after build
    npm prune --production

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/kibela-mcp-server
    cp -r . $out/libexec/kibela-mcp-server/

    mkdir -p $out/bin
    makeWrapper ${nodejs_24}/bin/node $out/bin/kibela-mcp-server \
      --add-flags "$out/libexec/kibela-mcp-server/bin/cli.mjs" \
      --set NODE_ENV "production"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kibela's official MCP Server";
    homepage = "https://github.com/kibela/kibela-mcp-server";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "kibela-mcp-server";
  };
}
