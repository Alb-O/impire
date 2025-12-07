# Desktop home-manager profile
# Extends shared profile with graphical desktop features
# Consolidates shared + desktop features for a complete desktop environment
{ imp, registry, ... }:
{
  imports =
    # Base shared profile (CLI, fonts, etc)
    [ registry.modules.home.profiles.shared ]
    ++ (imp.imports [
      # Desktop-specific features
      registry.modules.home.features.desktop.blender
      registry.modules.home.features.desktop.clipboard
      registry.modules.home.features.desktop.firefox
      registry.modules.home.features.desktop.gtk
      registry.modules.home.features.desktop.helium
      registry.modules.home.features.desktop.kakoune
      registry.modules.home.features.desktop.kitty
      registry.modules.home.features.desktop.mpv
      registry.modules.home.features.desktop.mako
      registry.modules.home.features.desktop.niri
      registry.modules.home.features.desktop.polkit
      registry.modules.home.features.desktop.sillytavern
      registry.modules.home.features.desktop.vscode
      registry.modules.home.features.desktop.zed
    ]);
}
