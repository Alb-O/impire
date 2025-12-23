/**
  A lightweight, secure, and feature-rich Discord terminal (TUI) client.
*/
let
  mod =
    { pkgs, lib, ... }:
    {
      home.packages = [
        pkgs.discordo
      ];
    };
in
{
  __exports.desktop.hm.value = mod;
  __module = mod;
}
