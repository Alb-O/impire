{
  users.albert = {
    isNormalUser = true;
    description = "Albert O'Shea";
    initialPassword = "changeme";
    extraGroups = [
      "wheel"
      "audio"
      "video"
    ];
  };

  users.root.initialPassword = "changeme";
}
