{
  description = "Declarative user environment that eliminates manual setup by defining your entire development and daily-use software stack as code.";

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
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    voicevox-cli = {
      url = "github:usabarashi/voicevox-cli?";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      mac-app-util,
      flake-utils,
      voicevox-cli,
      ...
    }:
    let
      lib = nixpkgs.lib;

      env = import ./lib/env.nix { inherit lib; };
      mkFlakeInputs =
        system:
        builtins.mapAttrs (
          name: input: if input ? packages.${system}.default then input.packages.${system}.default else input
        ) inputs;

      builders = import ./lib/builders.nix {
        inherit
          lib
          nix-darwin
          home-manager
          # mac-app-util
          mkFlakeInputs
          ;
      };

      homeModules = {
        darwin = import ./home/darwin;
        work = import ./home/work;
      };
      hostPaths = {
        private = ./hosts/private;
        work = ./hosts/work;
      };

      configs = import ./lib/configs.nix { inherit lib homeModules hostPaths; };

      selectedConfig =
        if (builtins.tryEval env.hostPurpose).success then configs.selectConfig env.hostPurpose else null;

      currentSystem = builtins.currentSystem;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
            uv
          ];
        };
      }
    )
    // {
      darwinConfigurations =
        if selectedConfig != null then
          {
            default = builders.mkDarwinSystem {
              system = currentSystem;
              userName = env.currentUser;
              repoPath = env.repoPath;
              inherit (selectedConfig) homeModule;
            };
          }
        else
          { };

      nixosConfigurations = { };
    };
}
