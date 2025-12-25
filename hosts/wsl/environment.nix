# Environment configuration for WSL
{ pkgs, ... }:
{
  # Packages needed for NAS mount
  systemPackages = [ pkgs.cifs-utils ];
}
