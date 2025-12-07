# Desktop feature - basic graphical desktop setup
# Includes display manager, fonts, and common desktop services
{ pkgs, lib, ... }:
{
  # Display manager
  services.displayManager = {
    enable = true;
    gdm.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.zed-mono
    fira-sans
    roboto
  ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Security
  security.rtkit.enable = true;

  # Essential desktop packages
  environment.systemPackages = with pkgs; [
    alacritty
  ];
}
