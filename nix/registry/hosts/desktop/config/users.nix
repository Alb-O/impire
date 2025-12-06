# User accounts for desktop
{
  users.albert = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "libvirtd"
    ];
    description = "Albert O'Shea";
    initialPassword = "changeme";
  };
}
