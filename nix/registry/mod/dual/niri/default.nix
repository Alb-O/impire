/**
  Niri feature.

  Niri Wayland compositor configuration.
  HM: User configuration (config.kdl)
  OS: System-level compositor enablement and packages
*/
let
  hm =
    { ... }:
    {
      xdg.configFile."niri" = {
        enable = true;
        source = ./config;
        recursive = true;
      };
    };
  os =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        alacritty
      ];
    };
in
{
  __exports.desktop.hm.value = hm;
  __exports.desktop.os.value = os;
  __module = os;
}
