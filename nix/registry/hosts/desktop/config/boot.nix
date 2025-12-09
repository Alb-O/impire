# Boot configuration for desktop
# Limine bootloader, nvidia kernel params, AMD/nvidia modules
{
  kernelParams = [
    "usbcore.autosuspend=-1"
    "usbhid.mousepoll=1"
    "usbcore.quirks=046d:c548:gki"
    "processor.ignore_ppc=1"
    "initcall_blacklist=amd_pstate_init"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  kernelModules = [
    "kvm-amd"
    "hid-logitech-dj"
    "hid-logitech-hidpp"
    "k10temp"
    "nct6775"
  ];

  initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  supportedFilesystems = [ "ntfs" ];

  extraModprobeConfig = ''
    options nvidia_drm nvidia_uvm modeset=1 fbdev=1
  '';

  loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false;
    limine = {
      enable = true;
      extraConfig = "timeout: 0";
    };
  };
}
