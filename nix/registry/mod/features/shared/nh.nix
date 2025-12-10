/**
  nh feature.

  Modern Nix helper utility with better UX for NixOS, Home Manager, and Darwin.
  Provides unified CLI for system management and automatic cleanup services.
*/
let
  flakePath = "/home/albert/imp.devspace/impire";

  # Home Manager configuration
  hmMod =
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

  # NixOS configuration
  nixosMod =
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
  __exports."shared.hm".value = hmMod;
  __exports."shared.nixos".value = nixosMod;
  __module = hmMod;
  __functor = _: hmMod;
}
