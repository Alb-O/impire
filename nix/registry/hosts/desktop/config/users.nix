# Desktop-specific user config - extends shared base user
# Base config provides: wheel, audio, video
# This adds desktop-specific groups
{
  users.albert.extraGroups = [
    "wheel" # From shared
    "audio" # From shared
    "video" # From shared
    "networkmanager" # Desktop-specific: WiFi management
    "libvirtd" # Desktop-specific: VM management
  ];
}
