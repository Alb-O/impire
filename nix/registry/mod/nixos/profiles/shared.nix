# Shared NixOS profile
# Base configuration for all hosts: nix settings, fonts, SSH, networking
# Consolidates base + shared NixOS features
{ imp, registry, ... }:
{
  imports = [
    registry.mod.nixos.base
  ]
  ++ (imp.imports [
    # Shared features (non-graphical)
    registry.mod.nixos.features.shared.fonts
    registry.mod.nixos.features.shared.networking
    registry.mod.nixos.features.shared.shell-init
    registry.mod.nixos.features.shared.sops
    registry.mod.nixos.features.shared.ssh
  ]);
}
