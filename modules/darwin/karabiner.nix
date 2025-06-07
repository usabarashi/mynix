{ config, pkgs, ... }:

{
  home.file.".config/karabiner/karabiner.json" = {
    source = ../../config/karabiner/karabiner.json;
    force = true;
  };
  
  home.activation.karabinerRestart = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/.config/karabiner/karabiner.json" ]; then
      ${pkgs.procps}/bin/pkill karabiner_grabber 2>/dev/null || true
      ${pkgs.procps}/bin/pkill karabiner_observer 2>/dev/null || true
      sleep 1
      if command -v karabiner_cli >/dev/null 2>&1; then
        karabiner_cli --reload-config 2>/dev/null || true
      fi
    fi
  '';
}
