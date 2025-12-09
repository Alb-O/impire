/**
  Niri Wayland compositor user configuration.
*/
let
  mod =
    { pkgs, ... }:
    let
      niriConfig = builtins.readFile ./config.kdl;
    in
    {
      xdg.configFile."niri/config.kdl" = {
        enable = true;
        source = pkgs.writeText "niri-config.kdl" niriConfig;
      };
    };
in
{
  __exports."desktop.hm".value = mod;
  __module = mod;
  __functor = _: mod;
}
