/**
  Standalone Home Manager desktop role.

  For use with `home-manager switch --flake .#albert@desktop`.
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
