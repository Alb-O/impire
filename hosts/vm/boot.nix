# Boot configuration for VM
{
  loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };
}
