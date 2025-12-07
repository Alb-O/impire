# Desktop NixOS profile
# Extends shared profile with desktop environment features
# Consolidates shared + desktop features for graphical workstations
{ imp, registry, ... }:
{
  imports =
    # Base shared profile
    [ registry.mod.nixos.profiles.shared ]
    ++ (imp.imports [
      # Desktop-specific features (common to all desktop hosts)
      registry.mod.nixos.features.desktop.desktop
      registry.mod.nixos.features.desktop.wayland
    ]);
}
