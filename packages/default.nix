{ pkgs }:

{
  blackhole-2ch = pkgs.callPackage ./blackhole-2ch { };
  custom-url-schema-iina = pkgs.callPackage ./custom-url-schema-iina { };
  docker-compose = pkgs.callPackage ./docker-compose { };
  gemini-cli = pkgs.callPackage ./gemini-cli.nix { };
  kibela-mcp-server = pkgs.callPackage ./kibela-mcp-server { };
}
