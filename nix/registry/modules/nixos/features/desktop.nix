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
    nerd-fonts.jetbrains-mono
    fira-sans
    roboto
    jetbrains-mono
  ];

  # Common desktop services
  services.printing.enable = true;

  # Audio via PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Security
  security.rtkit.enable = true;

  # Essential desktop packages
  environment.systemPackages = with pkgs; [
    alacritty
  ];
}
