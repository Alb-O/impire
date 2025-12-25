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
  __exports.desktop.nixos.value = mod;
  __module = mod;
}
