/**
  Desktop feature.

  Basic graphical desktop: display manager, fonts, bluetooth.
*/
let
  mod =
    { pkgs, ... }:
    {
      services.displayManager = {
        enable = true;
        gdm.enable = true;
      };

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
  __exports.desktop.nixos.value = mod;
  __module = mod;
}
