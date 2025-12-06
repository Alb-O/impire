# Environment configuration for desktop
{ pkgs, ... }:
{
  systemPackages = [ pkgs.lm_sensors ];
}
