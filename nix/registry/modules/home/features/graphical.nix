# Graphical feature - desktop utilities bundle
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpicker
    libinput
    solaar
  ];
}
