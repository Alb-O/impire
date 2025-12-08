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
    # Shared profile: CLI tooling that works everywhere (desktop, WSL, VM)
    registry.mod.hm.profiles.shared
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
