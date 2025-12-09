/**
  Desktop home-manager profile - graphical desktop features.

  Imports all modules exporting to `hm.profile.desktop`.
  Note: shared profile is imported separately by roles.
*/
{ exports, ... }:
let
  mod = {
    imports = [
      exports.hm.profile.desktop.__module
    ];
  };
in
{
  __module = mod;
}
