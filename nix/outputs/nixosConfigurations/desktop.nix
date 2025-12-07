# Desktop NixOS configuration
{
  self,
  lib,
  inputs,
  imp,
  registry,
  ...
}:
lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit
      self
      inputs
      imp
      registry
      ;
  };
  modules = imp.imports [
    registry.hosts.desktop
    # Desktop profile: merges base + all shared + all desktop features
    registry.mod.nixos.profiles.desktop
    # Additional desktop-specific features
    registry.mod.nixos.features.desktop.netshare
    registry.mod.nixos.features.desktop.tty
  ];
}
