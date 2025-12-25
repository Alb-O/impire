# Boot configuration for WSL
# Disable systemd-boot and grub (not used in WSL)
{ lib, ... }:
{
  loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = lib.mkForce false;
  };
}
