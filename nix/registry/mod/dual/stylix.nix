/**
  Stylix theme.

  Base16 color scheme: Gruvbox Dark Hard.
  Provides centralized theming for all targets.
*/
let
  sharedFonts = pkgs: {
    monospace = {
      name = "Iosevka Nerd Font";
      package = pkgs.nerd-fonts.iosevka;
    };
    sansSerif = {
      name = "Fira Sans";
      package = pkgs.fira-sans;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
    sizes.terminal = 18;
  };

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
        fonts = sharedFonts pkgs;
      };

      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
      ];

      home.sessionVariables.GTK2_RC_FILES = lib.mkForce "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  os =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        fonts = sharedFonts pkgs;
      };

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        roboto
        jetbrains-mono
      ];
    };
in
{
  __inputs.stylix = {
    url = "github:danth/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __exports.shared.hm.value = hm;
  __exports.shared.os.value = os;
  __module = hm;
}
