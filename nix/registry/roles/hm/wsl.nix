# Home Manager role: WSL bundle
# User config with shared modules only (no graphical features)
{ imp, exports, registry, ... }:
{
  imports = [
    exports.shared.hm.__module
  ] ++ imp.imports [
    registry.users.albert
  ];
}
