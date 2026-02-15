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
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    voicevox-cli = {
      url = "github:usabarashi/voicevox-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    serena = {
      url = "github:oraios/serena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      flake-utils,
      voicevox-cli,
      serena,
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

      currentSystem = builtins.currentSystem;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        darwinRebuild = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
        mkApplyApp = name: {
          type = "app";
          program = toString (
            pkgs.writeShellScript "apply-${name}" ''
              set -euo pipefail
              echo "Applying '${name}' configuration... (sudo password may be required)"
              sudo env \
                CURRENT_USER="''${CURRENT_USER:-$(whoami)}" \
                MYNIX_REPO_PATH="''${MYNIX_REPO_PATH:-$(pwd)}" \
                ${darwinRebuild} switch --flake ".#${name}" --impure "$@"
            ''
          );
        };
      in
      {
        apps = {
          private = mkApplyApp "private";
          work = mkApplyApp "work";
        };

        formatter = pkgs.nixfmt-tree;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
            nixfmt-tree
          ];
        };
      }
    )
    // {
      darwinConfigurations = {
        private = builders.mkDarwinSystem {
          system = currentSystem;
          userName = env.currentUser;
          repoPath = env.repoPath;
          homeModule = homeModules.darwin;
          hostPath = hostPaths.private;
        };
        work = builders.mkDarwinSystem {
          system = currentSystem;
          userName = env.currentUser;
          repoPath = env.repoPath;
          homeModule = homeModules.work;
          hostPath = hostPaths.work;
        };
      };

      nixosConfigurations = { };
    };
}
