# see: https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/virtualization/colima
#
# Switch docker context.
#   % docker context use colima
#   % docker context ls
{ pkgs, ... }:

{
  home.packages = with pkgs; [ colima ];
}
