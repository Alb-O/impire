/**
  Fonts feature.
*/
let
  mod =
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
    };
in
{
  __exports."shared.nixos".value = mod;
  __module = mod;
  __functor = _: mod;
}
