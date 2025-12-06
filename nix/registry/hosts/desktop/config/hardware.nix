# Hardware configuration for desktop
# AMD CPU, Nvidia GPU, fan control
{ config, lib, ... }:
{
  cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
