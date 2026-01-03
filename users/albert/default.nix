/**
  Albert's Home Manager user config.

  Identity, secrets path, and git settings. Imported by roles.
*/
{
  lib,
  config,
  ...
}:
{
  programs.home-manager.enable = true;
  home = {
    username = "albert";
    homeDirectory = "/home/albert";
    stateVersion = "24.05";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets."nix/github-access-tokens" = {
      path = "${config.home.homeDirectory}/.config/nix/access-tokens";
    };
  };

  nix.extraOptions = ''
    !include ${config.home.homeDirectory}/.config/nix/access-tokens
  '';

  programs.git.settings.user = {
    name = lib.mkDefault "Albert O'Shea";
    email = lib.mkDefault "albertoshea2@gmail.com";
  };
}
