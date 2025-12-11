/**
  Niri feature.

  Niri Wayland compositor configuration.
  HM: User configuration (config.kdl)
  OS: System-level compositor enablement and packages
*/
let
  hm =
    { pkgs, ... }:
    let
      niriConfig = builtins.readFile ./config.kdl;
    in
    {
      xdg.configFile."niri/config.kdl" = {
        enable = true;
        source = pkgs.writeText "niri-config.kdl" niriConfig;
      };
    };
  os =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        alacritty
      ];
    };
in
{
  __exports."desktop.hm".value = hm;
  __exports."desktop.os".value = os;
  __module = hm;
  __functor = _: hm;
}
