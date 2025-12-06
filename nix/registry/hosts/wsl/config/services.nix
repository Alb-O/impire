# Services for WSL
# Disable graphical services not used in WSL
{ lib, ... }:
{
  openssh.enable = lib.mkForce false;
  xserver.enable = lib.mkForce false;
  displayManager.enable = lib.mkForce false;
}
