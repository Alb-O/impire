/**
  NixOS base configuration.

  Shared settings for all hosts: nix-settings, essential packages.
*/
let
  mod =
    {
      self,
      lib,
      pkgs,
      ...
    }:
    {
      nix = {
        optimise.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
        channel.enable = false;
      };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = lib.attrValues (self.overlays or { });
      };

      security.sudo.wheelNeedsPassword = false;

      i18n.defaultLocale = "en_US.UTF-8";

      console = {
        font = "Lat2-Terminus16";
        keyMap = lib.mkDefault "us";
      };

      environment.systemPackages = with pkgs; [
        vim
        wget
        curl
        git
        htop
        ripgrep
        fd
        home-manager
      ];
    };
in
{
  __exports."shared.os".value = mod;
  __module = mod;
  __functor = _: mod;
}
