{
  description = "Composition Root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vdh-cli = {
      url = "github:usabarashi/vdh-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, mac-app-util, vdh-cli, ... }:
    let
      # Read environment variable for repository path
      # Note: Requires --impure flag for nix build/eval commands to access environment variables
      # Usage: nix build .#darwinConfigurations.HOST.system --impure
      repoPath = builtins.getEnv "MYNIX_REPO_PATH";
      actualRepoPath =
        if repoPath != "" then repoPath
        else builtins.throw "🫛 MYNIX_REPO_PATH environment variable must be set for multi-user sharing. Please set it to your repository path.";

      # Create darwin system configuration with required parameters for multi-user sharing
      mkDarwinSystem = { system, hostPath, homeModule, userName, includeVdhCli ? true }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            hostPath
            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${userName} = homeModule;
              home-manager.extraSpecialArgs = {
                repoPath = actualRepoPath;
              } // (if includeVdhCli then { inherit vdh-cli; } else { });
            }
            mac-app-util.darwinModules.default
          ];
        };
    in
    {
      darwinConfigurations = {
        H3JN70RHWY = mkDarwinSystem {
          system = "aarch64-darwin";
          hostPath = ./hosts/H3JN70RHWY;
          homeModule = import ./home/darwin;
          userName = "gen";
        };

        Mac093 = mkDarwinSystem {
          system = "aarch64-darwin";
          hostPath = ./hosts/Mac093;
          homeModule = import ./home/work;
          userName = "motoki_kamimura";
          includeVdhCli = false;
        };
      };
    };
}
