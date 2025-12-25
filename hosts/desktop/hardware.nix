# Hardware configuration for desktop
# AMD CPU, Nvidia GPU, fan control, Logitech wireless
{ config, lib, ... }:
{
  cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Logitech wireless (Bolt/Unifying receiver) - enables udev rules for Solaar
  logitech.wireless = {
    enable = true;
    enableGraphical = true; # for solaar GUI
  };

  nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
  };

  fancontrol = {
    enable = true;
    config = "";
  };
}
