/**
  Kitty GPU-accelerated terminal.
*/
let
  mod =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      xdg.configFile."kitty/tab_bar.py".text =
        builtins.replaceStrings
          [ "@cyan@" "@blue@" "@orange@" "@base1@" "@base0@" ]
          [
            config.lib.stylix.colors.base0C
            config.lib.stylix.colors.base0D
            config.lib.stylix.colors.base09
            config.lib.stylix.colors.base01
            config.lib.stylix.colors.base00
          ]
          (builtins.readFile ./tab_bar.py);

      programs.kitty = {
        enable = true;

        settings = lib.mkForce {
          shell_integration = "enabled";
          term = "xterm-256color";
          shell = "nu";
          strip_trailing_spaces = "smart";
          focus_follows_mouse = "yes";
          enable_audio_bell = "no";

          window_padding_width = "0 20 20";
          cursor_shape = "beam";
          cursor_blink_interval = "0.25";
          hide_window_decorations = "yes";

          tab_bar_min_tabs = "1";
          tab_bar_edge = "top";
          tab_bar_margin_height = "5.0 5.0";
          tab_bar_style = "custom";
          tab_powerline_style = "round";
          tab_title_template = "{index}: {title}";
        };

        extraConfig = "tab_bar_background #${config.lib.stylix.colors.base00}";
      };
    };
in
{
  __exports.desktop.hm.value = mod;
  __module = mod;
}
