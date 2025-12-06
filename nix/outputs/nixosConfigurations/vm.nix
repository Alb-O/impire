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
  specialArgs = { inherit self inputs imp registry; };
  modules = imp.imports [
    registry.hosts.vm
    registry.modules.nixos.base
    registry.modules.nixos.features.desktop.desktop
    registry.modules.nixos.features.shared.shell-init
    registry.modules.nixos.features.shared.sops
  ];
}
