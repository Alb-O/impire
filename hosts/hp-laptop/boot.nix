# Boot configuration for hp-laptop
# AMD kernel modules
{
  initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  kernelModules = [ "kvm-amd" ];
  blacklistedKernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];

  loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
