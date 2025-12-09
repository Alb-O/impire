# Home Manager role: WSL bundle
# User config with shared profile only (no graphical features)
{ imp, registry, ... }:
{
  imports = imp.imports [
    registry.users.albert
    registry.mod.hm.profiles.shared
  ];
}
