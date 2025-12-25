# Services for WSL
# Disable graphical services not used in WSL
{ lib, ... }:
{
  xserver.enable = lib.mkForce false;
  displayManager.enable = lib.mkForce false;
}
