# NixOS role: WSL bundle
# Uses the WSL host module (already includes shared profile + Home Manager)
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.wsl
  ];
}
