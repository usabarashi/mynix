{ config, pkgs, lib, repoPath ? null, ... }:

let
  useSymlinks = repoPath != null && repoPath != "";
in
{
  home.file.".config/karabiner/karabiner.json" =
    if useSymlinks then {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/karabiner/karabiner.json";
      force = true;
    } else {
      source = ../../config/karabiner/karabiner.json;
      force = true;
    };
}
