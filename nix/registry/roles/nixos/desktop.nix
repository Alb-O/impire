# NixOS role: desktop host bundle
# Collects the desktop host plus extra desktop-only features wired in nixosConfigurations
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.desktop
    registry.mod.nixos.features.desktop.netshare
    registry.mod.nixos.features.desktop.tty
  ];
}
