/**
  Stylix theme.

  Base16 color scheme: Gruvbox Dark Hard.
  Provides centralized theming for all targets.
*/
let
  hm =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        targets.firefox.profileNames = [
          "albert"
          "work"
        ];
        override = {
          base00 = "#000000";
        };
        fonts = {
          monospace = {
            name = "CozetteVector";
            package = pkgs.cozette;
          };
        };
        fonts.sizes.terminal = 18;
      };

      home.sessionVariables.GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  os =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      };
    };
in
{
  __inputs.stylix = {
    url = "github:danth/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __exports.shared.hm.value = hm;
  __exports.shared.os.value = os;
  __exports.desktop.nixos.value = os;
  __module = hm;
}
