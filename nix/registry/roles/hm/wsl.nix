/**
  Standalone Home Manager WSL role.

  For use with `home-manager switch --flake .#albert@wsl`.
*/
{
  imp,
  exports,
  registry,
  ...
}:
{
  imports = [
    exports.shared.hm.__module
  ]
  ++ imp.imports [
    registry.users.albert
  ];
}
