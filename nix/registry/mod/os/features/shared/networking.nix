/**
  Networking feature.
*/
let
  mod =
    { lib, ... }:
    {
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall.enable = lib.mkDefault true;
      };
    };
in
{
  __exports."shared.os".value = mod;
  __module = mod;
  __functor = _: mod;
}
