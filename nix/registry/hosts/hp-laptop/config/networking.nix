# Networking configuration for hp-laptop
{ lib, ... }:
{
  hostName = "hp-laptop";
  useDHCP = lib.mkDefault true;
  networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
      iPhone = {
        connection = {
          id = "iPhone";
          type = "wifi";
          autoconnect = true;
        };
        wifi = {
          ssid = "iPhone";
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "pbxtpfj1tmi23";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          method = "auto";
        };
      };
    };
  };
}
