# Networking feature - NetworkManager and firewall
{ lib, ... }:
{
  networking = {
    networkmanager.enable = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;
  };
}
