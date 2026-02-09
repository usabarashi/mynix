{ ... }:
{
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0; # Sunday
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    interval = {
      Weekday = 0; # Sunday
      Hour = 1; # 1 hour after GC
      Minute = 0;
    };
  };
}
