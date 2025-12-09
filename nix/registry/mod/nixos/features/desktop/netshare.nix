/**
  Netshare feature.

  NFS/CIFS client tooling.
*/
let
  mod =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nfs-utils
        cifs-utils
      ];
    };
in
{
  __exports."nixos.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
