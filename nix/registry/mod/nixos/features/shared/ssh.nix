/**
  SSH feature.

  OpenSSH server with hardened defaults.
*/
let
  mod =
    { lib, ... }:
    {
      services.openssh = {
        enable = lib.mkDefault true;
        settings = {
          PermitRootLogin = lib.mkDefault "no";
          PasswordAuthentication = lib.mkDefault false;
        };
      };
    };
in
{
  __exports."shared.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
