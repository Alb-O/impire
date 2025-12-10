/**
  Keyboard feature.

  keyd keyboard remapping - swaps Caps Lock and Escape.
*/
let
  mod =
    { ... }:
    {
      services.keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = [ "*" ];
            settings = {
              main = {
                capslock = "esc";
                esc = "capslock";
              };
            };
          };
        };
      };
    };
in
{
  __exports."desktop.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
