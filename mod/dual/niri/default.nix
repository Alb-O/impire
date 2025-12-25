/**
  Niri feature.

  Niri Wayland compositor configuration.
  HM: User configuration (config.kdl)
  OS: System-level compositor enablement and packages
*/
let
  hm =
    { config, ... }:
    {
      xdg.configFile."niri/config.kdl".source = ./config/config.kdl;
      xdg.configFile."niri/binds.kdl".source = ./config/binds.kdl;
      xdg.configFile."niri/input.kdl".source = ./config/input.kdl;
      xdg.configFile."niri/monitors.kdl".source = ./config/monitors.kdl;
      xdg.configFile."niri/rules.kdl".source = ./config/rules.kdl;
      xdg.configFile."niri/layout.kdl".text =
        builtins.replaceStrings
          [ "@base03@" "@cyan@" "@base02@" "@base01@" ]
          [
            config.lib.stylix.colors.base00
            config.lib.stylix.colors.base0C
            config.lib.stylix.colors.base01
            config.lib.stylix.colors.base02
          ]
          (builtins.readFile ./config/layout.kdl);
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
