{
  lib,
  nix-darwin,
  home-manager,
  # mac-app-util,
  mkFlakeInputs,
}:

{
  mkDarwinSystem =
    {
      system,
      userName,
      homeModule,
      repoPath,
    }:
    let
      homeDirectory = "/Users/${userName}";
      hostConfig =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          system.stateVersion = 4;
          ids.gids.nixbld = 350; # Use fixed GID instead of runtime detection
          nixpkgs.overlays = import ../lib/overlays.nix {
            flakeInputs = mkFlakeInputs system;
          };
          nixpkgs.config.allowUnfree = true;
          users.users.${userName} = {
            home = homeDirectory;
            shell = pkgs.zsh;
          };
        };
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit userName homeDirectory;
      };
      modules = [
        hostConfig
        home-manager.darwinModules.home-manager
        {
          home-manager.sharedModules = [
            # mac-app-util.homeManagerModules.default
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${userName} = homeModule;
          home-manager.extraSpecialArgs = {
            inherit repoPath userName homeDirectory;
            flakeInputs = mkFlakeInputs system;
          };
        }
        # mac-app-util.darwinModules.default
      ];
    };
}
