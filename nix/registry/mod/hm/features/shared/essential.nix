# Essential feature - baseline packages for all profiles
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    curl
    fastfetch
    git
    jq
    just
    nano
    nmap
    lsof
  ];
}
