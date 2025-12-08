# Desktop home-manager profile
# Extends shared profile with graphical desktop features
# Consolidates shared + desktop features for a complete desktop environment
{ imp, registry, ... }:
{
  imports = imp.imports [
    # Desktop-specific features (shared profile imported separately)
    registry.mod.hm.features.desktop.blender
    registry.mod.hm.features.desktop.clipboard
    registry.mod.hm.features.desktop.firefox
    registry.mod.hm.features.desktop.gtk
    registry.mod.hm.features.desktop.helium
    registry.mod.hm.features.desktop.kakoune
    registry.mod.hm.features.desktop.kitty
    registry.mod.hm.features.desktop.mpv
    registry.mod.hm.features.desktop.mako
    registry.mod.hm.features.desktop.niri
    registry.mod.hm.features.desktop.polkit
    registry.mod.hm.features.desktop.sillytavern
    registry.mod.hm.features.desktop.vscode
    registry.mod.hm.features.desktop.zed
  ];
}
