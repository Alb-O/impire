# Fonts feature - shared font configuration
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    fira-sans
    roboto
    jetbrains-mono
  ];
}
