/**
  Albert's Home Manager configuration.

  User identity and secrets - modules imported by roles.
*/
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

  home = {
    username = "albert";
    homeDirectory = "/home/albert";
    stateVersion = "24.05";
  };

  sops.defaultSopsFile = ./secrets.yaml;

  programs.git.settings.user = {
    name = lib.mkDefault "Albert O'Shea";
    email = lib.mkDefault "albertoshea2@gmail.com";
  };
}
