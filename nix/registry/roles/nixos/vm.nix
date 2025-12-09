/**
  NixOS VM role.
*/
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.vm
  ];
}
