# Home Manager role: desktop bundle
# Combines user config with shared + desktop profiles
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.users.albert
    registry.mod.hm.profiles.shared
    registry.mod.hm.profiles.desktop
  ];
}
