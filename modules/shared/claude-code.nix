{ config, pkgs, lib, ... }:

{
  home.file = {
    ".config/claude-code/settings.local.json" = {
      source = ../../config/claude/settings.local.json;
    };
  };
}
