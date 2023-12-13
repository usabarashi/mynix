{ pkgs, ... }:
{
  users.users.gen = {
    home = "/Users/gen";
  };

  services.nix-daemon.enable = true;
  time.timeZone = "Asia/Tokyo";
}
