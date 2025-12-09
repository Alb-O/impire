# Services configuration for desktop
# Xserver nvidia drivers, udev rules for USB devices
{
  xserver.videoDrivers = [ "nvidia" ];
  
  # USB device power management - Logitech wireless devices
  # Prevents stuttering/lag by disabling USB autosuspend
  udev.extraRules = ''
    # Logitech USB receivers - disable autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{power/control}="on"
    
    # Logitech Bolt Receiver (MX Master 4)
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c548", ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
  '';
}
