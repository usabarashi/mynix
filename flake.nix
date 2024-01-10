{
  description = "Composition Root";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";

    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , darwin
    , home-manager
    , ...
    }@inputs:
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

        Mac093 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/Mac093
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.motoki_kamimura = import ./home/work;
            }
          ];
        };

      };
    };
}
