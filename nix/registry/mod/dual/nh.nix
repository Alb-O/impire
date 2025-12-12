/**
  nh feature.

  Modern Nix helper utility with better UX for NixOS, Home Manager, and Darwin.
  Provides unified CLI for system management and automatic cleanup services.
*/
let
  flakePath = "/home/albert/workspace/impire";
  hm =
    { ... }:
    {
      programs.nh = {
        enable = true;
        flake = flakePath;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 5";
        };
      };
    };
  os =
    { ... }:
    {
      programs.nh = {
        enable = true;
        flake = flakePath;
        clean = {
          enable = true;
          dates = "03:00";
          extraArgs = "--keep-since 7d --keep 5";
        };
      };
    };
in
{
  __exports.shared.hm.value = hm;
  __exports.shared.os.value = os;
  __module = hm;
  __functor = _: hm;
}
