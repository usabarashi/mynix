{ config, pkgs, lib, ... }:

{
  home.file = {
    ".aider.conf.yml" = {
      source = ../../config/aider/aider.conf.yml;
    };
  };
}
