# Shared NixOS profile
# Base configuration for all hosts: nix settings, fonts, SSH, networking
# Consolidates base + shared NixOS features
{ imp, registry, ... }:
{
  imports = [
    registry.modules.nixos.base
  ]
  ++ (imp.imports [
    # Shared features (non-graphical)
    registry.modules.nixos.features.shared.fonts
    registry.modules.nixos.features.shared.networking
    registry.modules.nixos.features.shared.shell-init
    registry.modules.nixos.features.shared.sops
    registry.modules.nixos.features.shared.ssh
  ]);
}
