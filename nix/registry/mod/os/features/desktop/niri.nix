/**
  Niri feature.

  Niri Wayland compositor.
*/
let
  mod =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        alacritty
      ];
    };
in
{
  __exports."desktop.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
