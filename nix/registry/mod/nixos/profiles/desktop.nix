/**
  Desktop NixOS profile - desktop environment features.

  Imports all modules exporting to `nixos.profile.desktop`.
  Note: shared profile should be imported separately by consumers.
*/
{ exports, ... }:
let
  mod = {
    imports = [
      exports.nixos.profile.desktop.__module
    ];
  };
in
{
  __module = mod;
}
