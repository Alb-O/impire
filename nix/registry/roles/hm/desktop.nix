/**
  Home Manager desktop role.

  Combines user config with shared + desktop modules.
*/
{ imp, exports, registry, ... }:
{
  imports = [
    exports.shared.hm.__module
    exports.desktop.hm.__module
  ] ++ imp.imports [
    registry.users.albert
  ];
}
