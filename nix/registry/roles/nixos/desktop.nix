/**
  NixOS desktop role.

  Bundles desktop host with extra desktop-only features.
*/
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.desktop
    registry.mod.nixos.features.desktop.netshare
    registry.mod.nixos.features.desktop.tty
  ];
}
