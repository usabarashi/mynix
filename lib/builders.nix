{ lib, nix-darwin, home-manager, mac-app-util, inputs, customPackages }:

{
  mkDarwinSystem = { 
    system, 
    userName, 
    homeModule, 
    repoPath
  }:
    let
      homeDirectory = "/Users/${userName}";
      hostConfig = { config, lib, pkgs, ... }: 
        let
          currentNixbldGid = 
            let
              gidCheck = pkgs.runCommand "check-nixbld-gid" {} ''
                if /usr/bin/dscl . -read /Groups/nixbld PrimaryGroupID 2>/dev/null | ${pkgs.gnugrep}/bin/grep -o '[0-9]*' > $out; then
                  echo "Found existing nixbld GID: $(cat $out)" >&2
                else
                  echo "350" > $out
                  echo "Using default GID 350" >&2
                fi
              '';
            in
              lib.toInt (lib.removeSuffix "\n" (builtins.readFile gidCheck));
        in
        {
          system.stateVersion = 4;
          ids.gids.nixbld = currentNixbldGid;
          nixpkgs.overlays = import ../lib/overlays.nix { inherit inputs customPackages; };
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
            mac-app-util.homeManagerModules.default
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${userName} = homeModule;
          home-manager.extraSpecialArgs = {
            inherit repoPath userName homeDirectory;
          };
        }
        mac-app-util.darwinModules.default
      ];
    };
}