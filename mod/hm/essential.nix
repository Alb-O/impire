/**
  Essential feature.

  Baseline packages for all profiles.
*/
let
  mod =
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
        tmux
      ];
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
