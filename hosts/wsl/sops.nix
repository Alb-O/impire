# Sops secrets configuration for WSL
{ config, ... }:
{

  defaultSopsFile = ../secrets.yaml;
  age.keyFile = "/home/albert/.config/sops/age/keys.txt";

  secrets."nas/smb-credentials" = {
    mode = "0400";
    owner = "root";
    group = "root";
  };

}
