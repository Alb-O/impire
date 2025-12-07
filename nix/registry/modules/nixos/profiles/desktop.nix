# Desktop NixOS profile
# Extends shared profile with desktop environment features
# Consolidates shared + desktop features for graphical workstations
{ imp, registry, ... }:
{
  imports =
    # Base shared profile
    [ registry.modules.nixos.profiles.shared ]
    ++ (imp.imports [
      # Desktop-specific features (common to all desktop hosts)
      registry.modules.nixos.features.desktop.desktop
      registry.modules.nixos.features.desktop.wayland
    ]);
}
