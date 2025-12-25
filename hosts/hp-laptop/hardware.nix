# Hardware configuration for hp-laptop
# AMD CPU
{ config, lib, ... }:
{
  cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
