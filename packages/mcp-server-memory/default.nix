{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
}:

buildNpmPackage rec {
  pname = "mcp-server-memory";
  version = "2026.1.26";

  src = fetchurl {
    url = "https://registry.npmjs.org/@modelcontextprotocol/server-memory/-/server-memory-${version}.tgz";
    hash = "sha256-cD9iexZwFnV0ofEZAxgWSBvgENaLcv8JypuZ1x5e9SQ=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    # Remove prepare script to avoid TypeScript build
    ${jq}/bin/jq 'del(.scripts.prepare)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-hAi44Kvjvn65kwr2M+8pZw3l+ezOQbux9/7xkZtKS+I=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "MCP server for enabling memory for Claude through a knowledge graph";
    homepage = "https://github.com/modelcontextprotocol/servers";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "mcp-server-memory";
  };
}
