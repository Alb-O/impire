# VM NixOS configuration - run with: nix run .#vm
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
    registry.hosts.vm
    # Desktop profile: merges base + all shared + all desktop features
    registry.mod.nixos.profiles.desktop
  ];
}
