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
  __exports."nixos.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
