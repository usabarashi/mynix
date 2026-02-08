{ pkgs }:

{
  blackhole-2ch = pkgs.callPackage ./blackhole-2ch { };
  claude-code-sandboxed = pkgs.callPackage ./claude-code-sandboxed { };
  custom-url-schema-iina = pkgs.callPackage ./custom-url-schema-iina { };
  docker-compose = pkgs.callPackage ./docker-compose { };
  gemini-cli-workforce = pkgs.callPackage ./gemini-cli-workforce { };
  mcp-server-memory = pkgs.callPackage ./mcp-server-memory { };
}
