{ ... }:
{
  users.users.gen = {
    home = "/Users/gen";
  };

  # See: https://daiderd.com/nix-darwin/manual/
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        NSAutomaticCapitalizationEnabled = false;
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

      dock = {
        autohide = true;
        launchanim = false;
        wvous-bl-corner = 1; # Disabled
        wvous-br-corner = 4; # Desktop
        wvous-tl-corner = 1; # Disabled
        wvous-tr-corner = 6; # Disable Screen Saver
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0; # Show the date
        ShowSeconds = true;
      };

      screensaver.askForPassword = true;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  time.timeZone = "Asia/Tokyo";
}
