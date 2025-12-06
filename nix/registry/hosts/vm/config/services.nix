# Services for VM
{ lib, ... }:
{
  openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  # Override gdm from desktop module; xfce uses lightdm
  displayManager.gdm.enable = lib.mkForce false;

  xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
  };
}
