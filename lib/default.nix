inputs@{ nixpkgs, ... }:

let
  lib = nixpkgs.lib;
  
  # Import independent modules
  envModule = import ./env.nix;
  configsModule = import ./configs.nix;
  systemsModule = import ./systems.nix;
  buildersModule = import ./builders.nix;
in
{
  # Pure library functions - no dependencies
  inherit envModule configsModule systemsModule buildersModule;
}