/**
  Kitty GPU-accelerated terminal with solarized dark theme.
*/
let
  mod =
    { ... }:
    {
      xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;

      programs.kitty = {
        enable = true;

        font = {
          name = "CozetteVector";
          size = 18;
        };

        settings = {
          shell_integration = "enabled";
          term = "xterm-256color";
          shell = "fish";
          strip_trailing_spaces = "smart";
          focus_follows_mouse = "yes";
          enable_audio_bell = "no";

          background_opacity = "1.0";
          window_padding_width = "0 20 20";
          cursor_shape = "beam";
          cursor_blink_interval = "0.25";
          hide_window_decorations = "yes";
          active_border_color = "#268bd2";

          tab_bar_min_tabs = "1";
          tab_bar_edge = "top";
          tab_bar_margin_height = "5.0 5.0";
          tab_bar_style = "custom";
          tab_powerline_style = "round";
          active_tab_foreground = "#002b36";
          inactive_tab_foreground = "#073642";
          active_tab_background = "#2aa198";
          inactive_tab_background = "#586e75";
          tab_bar_margin_color = "#002b36";
          tab_title_template = "{index}: {title}";

          foreground = "#839496";
          background = "#002b36";
          selection_background = "#073642";
          selection_foreground = "#93a1a1";
          cursor = "#839496";
          url_color = "#268bd2";

          # Black (Base02/Base01)
          color0 = "#073642";
          color8 = "#586e75";

          # Red
          color1 = "#dc322f";
          color9 = "#cb4b16";

          # Green
          color2 = "#859900";
          color10 = "#586e75";

          # Yellow
          color3 = "#b58900";
          color11 = "#657b83";

          # Blue
          color4 = "#268bd2";
          color12 = "#839496";

          # Magenta
          color5 = "#d33682";
          color13 = "#6c71c4";

          # Cyan
          color6 = "#2aa198";
          color14 = "#93a1a1";

          # White (Base2/Base3)
          color7 = "#eee8d5";
          color15 = "#fdf6e3";
        };
      };
    };
in
{
  __exports.desktop.hm.value = mod;
  __module = mod;
}
