# Albert's Home Manager configuration
# User identity and secrets - profiles imported by roles
{
  registry,
  imp,
  lib,
  ...
}:
{
  imports = imp.imports [
    registry.mod.hm.base
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
