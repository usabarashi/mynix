inputs@{ nixpkgs, ... }:

let
  # Import independent modules
  envModule = import ./env.nix;
  buildersModule = import ./builders.nix;
in
{
  # Pure library functions - no dependencies
  inherit
    envModule
    buildersModule
    ;
}
