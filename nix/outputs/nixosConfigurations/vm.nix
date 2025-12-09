# VM NixOS configuration - run with: nix run .#vm
{
  self,
  lib,
  inputs,
  imp,
  registry,
  exports,
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
      exports
      ;
  };
  modules = imp.imports [
    registry.hosts.vm
  ];
}
