# Shared base user configuration for all hosts
{
  users.albert = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Albert O'Shea";
    initialPassword = "changeme";
  };
}
