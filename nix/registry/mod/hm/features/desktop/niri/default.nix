# Niri feature - Niri Wayland compositor user configuration
# Provides config.kdl for the niri window manager
{ pkgs, ... }:
let
  niriConfig = builtins.readFile ./config.kdl;
in
{
  xdg.configFile."niri/config.kdl" = {
    enable = true;
    source = pkgs.writeText "niri-config.kdl" niriConfig;
  };
}
