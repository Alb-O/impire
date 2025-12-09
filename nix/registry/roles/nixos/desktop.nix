/**
  NixOS desktop role.

  Desktop host plus hardware-specific extras (netshare, tty).
*/
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.desktop
    registry.mod.nixos.features.desktop.netshare
    registry.mod.nixos.features.desktop.tty
  ];
}
