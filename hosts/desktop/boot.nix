# Boot configuration for desktop
# Limine bootloader, nvidia kernel params, AMD/nvidia modules
{
  # Blacklist Logitech HID++ drivers to test if they cause MX Master 4 stutter
  # Forces generic HID handling instead
  blacklistedKernelModules = [ "hid-logitech-hidpp" "hid-logitech-dj" ];

  kernelParams = [
    "processor.ignore_ppc=1"
    "initcall_blacklist=amd_pstate_init"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "resume=UUID=459d3fed-e5a3-4d17-ab68-fb2679849ea9"
  ];

  kernelModules = [
    "kvm-amd"
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
