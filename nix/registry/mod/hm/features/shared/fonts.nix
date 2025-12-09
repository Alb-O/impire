/**
  Fonts feature.

  Font packages for Home Manager.
*/
let
  mod =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.zed-mono
      ];
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
