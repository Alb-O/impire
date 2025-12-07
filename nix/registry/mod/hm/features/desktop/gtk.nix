# GTK feature - GTK2/GTK3 settings
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
}
