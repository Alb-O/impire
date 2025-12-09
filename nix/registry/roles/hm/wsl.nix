# Home Manager role: WSL bundle
# Minimal HM setup for WSL host
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.users.albert
  ];
}
