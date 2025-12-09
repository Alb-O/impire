/**
  Shared home-manager profile - CLI tooling and essentials.

  Works everywhere: desktop, WSL, VM.
  Imports all modules exporting to `hm.profile.shared`.
*/
{ exports, ... }:
let
  mod = {
    imports = [
      exports.hm.profile.shared.__module
    ];
  };
in
{
  __module = mod;
}
