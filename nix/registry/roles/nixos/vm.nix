# NixOS role: VM bundle
# Uses the VM host module (already includes desktop profile + Home Manager)
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.hosts.vm
  ];
}
