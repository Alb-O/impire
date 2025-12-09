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
      ];
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
