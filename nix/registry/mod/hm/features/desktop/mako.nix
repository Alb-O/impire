/**
  Mako notification daemon for Wayland sessions.
*/
let
  mod =
    { ... }:
    {
      services.mako = {
        enable = true;
        settings = {
          width = 400;
          height = 150;
          margin = "10";
          padding = "15";
          border-size = 2;
          border-radius = 0;
          default-timeout = 5000;
          ignore-timeout = true;
          layer = "overlay";
          anchor = "top-right";
        };
      };
    };
in
{
  __exports."hm.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
