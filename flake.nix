{
  description = "Composition Root";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    {
      darwinConfigurations = {
        H3JN70RHWY = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # nix-darwin setteings
            ./hosts/H3JN70RHWY
            {
              system.stateVersion = 5;
            }
            # home-manager settings
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.gen = import ./home/darwin;
            }
          ];
        };

        Mac093 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # nix-darwin setteings
            ./hosts/Mac093
            {
              system.stateVersion = 5;
            }
            # home-manager settings
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
