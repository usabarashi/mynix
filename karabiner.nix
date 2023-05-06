{ config, pkgs, ... }:

{
  home.file.".config/karabiner/karabiner.json".source = ./config/karabiner/karabiner.json;
}
