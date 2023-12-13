{
  description = "Composition Root";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    }:
    {
      darwinConfigurations = {
        H3JN70RHWY = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/H3JN70RHWY
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.gen = import ./home/darwin;
            }
          ];
        };
      };
    };
}
