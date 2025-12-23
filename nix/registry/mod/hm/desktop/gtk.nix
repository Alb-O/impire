/**
  GTK2/GTK3 theme and font settings.

  Overrides Stylix defaults for gtk2 config location.
*/
let
  mod =
    { config, lib, ... }:
    {
      gtk = {
        enable = true;
        gtk2.configLocation = lib.mkForce (config.xdg.configHome + "/gtk-2.0/gtkrc");
      };
    };
in
{
  __exports.desktop.hm.value = mod;
  __module = mod;
}
