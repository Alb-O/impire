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
    registry.mod.hm.base
    # Desktop profile: merges all shared + desktop features
    registry.mod.hm.profiles.desktop
  ];

  # User identity
  home = {
    username = "albert";
    homeDirectory = "/home/albert";
    stateVersion = "24.05";
  };

  # Sops secrets configuration
  sops.defaultSopsFile = ./secrets.yaml;

  # Git identity
  programs.git.settings.user = {
    name = lib.mkDefault "Albert O'Shea";
    email = lib.mkDefault "albertoshea2@gmail.com";
  };
}
