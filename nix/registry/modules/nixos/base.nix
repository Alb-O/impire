# NixOS base configuration
# Shared settings for all hosts - absorbs autix aspects: nix-settings, essential
{ self, lib, pkgs, ... }:
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
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
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
  ];
}
