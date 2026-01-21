/**
  Nix formatter using nixfmt (RFC-style).
*/
{ pkgs, ... }:
{
  programs.nixfmt.enable = true;
}
