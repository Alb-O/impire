/**
  NixOS WSL role.
*/
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.wsl
  ];
}
