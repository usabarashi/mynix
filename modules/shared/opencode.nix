{ config, pkgs, lib, ... }:

{
  home.file = {
    # See: https://github.com/opencode-ai/opencode
    "config/opencode/.opencode.json" = {
      source = ./../../config/opencode/.opencode.json;
    };
  };
}
