# User accounts for WSL
{
  users.albert = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Albert O'Shea";
    initialPassword = "changeme";
  };
}
