/**
  Desktop feature.

  Basic graphical desktop: display manager, fonts, bluetooth.
*/
let
  mod =
    { pkgs, lib, ... }:
    {
      services.displayManager = {
        enable = true;
        gdm.enable = true;
      };

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.zed-mono
        fira-sans
        roboto
      ];

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

      security.rtkit.enable = true;

      environment.systemPackages = with pkgs; [
        alacritty
      ];
    };
in
{
  __exports."desktop.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
