{
  description = "Custom packages for mynix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          blackhole-2ch = pkgs.callPackage ./blackhole-2ch { };
          custom-url-schema-iina = pkgs.callPackage ./custom-url-schema-iina { };
          docker-compose = pkgs.callPackage ./docker-compose { };
          kibela-mcp-server = pkgs.callPackage ./kibela-mcp-server { };
        }
      );

      default = forAllSystems (system: self.packages.${system});
    };
}