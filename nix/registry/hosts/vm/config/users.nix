# User accounts for VM
{
  users = {
    albert = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      description = "Albert O'Shea";
      initialPassword = "changeme";
    };
    root.initialPassword = "changeme";
  };
}
