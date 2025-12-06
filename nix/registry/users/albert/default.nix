# Albert's Home Manager configuration
# Base user config - imported by both desktop and wsl hosts
{
  registry,
  imp,
  lib,
  ...
}:
{
  imports = imp.imports [
    registry.modules.home.base
    registry.modules.home.features.essential
    registry.modules.home.features.cli
    registry.modules.home.features.ssh
    registry.modules.home.features.fonts
  ];

  # User identity
  home = {
    username = "albert";
    homeDirectory = "/home/albert";
    stateVersion = "24.05";
  };

  # Git identity
  programs.git.settings.user = {
    name = lib.mkDefault "Albert O'Shea";
    email = lib.mkDefault "albertoshea2@gmail.com";
  };

  xdg.enable = true;
}
