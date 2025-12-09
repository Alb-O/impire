/**
  Shared NixOS profile - base configuration for all hosts.

  Imports base config plus all modules exporting to `nixos.profile.shared`.
*/
{ exports, registry, ... }:
let
  mod = {
    imports = [
      registry.mod.nixos.base
      exports.nixos.profile.shared.__module
    ];
  };
in
{
  __module = mod;
}
