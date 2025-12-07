# Netshare feature - NFS/CIFS client tooling
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nfs-utils
    cifs-utils
  ];
}
