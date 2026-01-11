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
  __exports.desktop.os.value = mod;
  __module = mod;
}
