/**
  GTK2/GTK3 theme and font settings.
*/
let
  mod =
    { pkgs, config, ... }:
    {
      gtk = {
        enable = true;
        gtk2.configLocation = config.xdg.configHome + "/gtk-2.0/gtkrc";
        font = {
          name = "Fira Sans";
          package = pkgs.fira-sans;
          size = 13;
        };
      };
    };
in
{
  __exports."desktop.hm".value = mod;
  __module = mod;
  __functor = _: mod;
}
