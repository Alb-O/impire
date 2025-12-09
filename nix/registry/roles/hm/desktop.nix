# Home Manager role: desktop bundle
# Combines user config with desktop profile
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.users.albert
    registry.mod.hm.profiles.desktop
  ];
}
