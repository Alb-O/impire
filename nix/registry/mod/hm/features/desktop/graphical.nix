/**
  Desktop utilities bundle (hyprpicker, libinput, solaar).
*/
let
  mod =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        hyprpicker
        libinput
        solaar
      ];
    };
in
{
  __exports."hm.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
