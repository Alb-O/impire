/**
  Albert's Home Manager user config.

  Identity, secrets path, and git settings. Imported by roles.
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
