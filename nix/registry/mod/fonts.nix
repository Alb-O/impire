/**
  Fonts feature.

  Provides font packages for both Home Manager and NixOS.
  HM: User-level font packages
  OS: System-level font packages
*/
let
  hm =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.zed-mono
      ];
    };
  os =
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
  __exports.shared.hm.value = hm;
  __exports.shared.os.value = os;
  __module = hm;
  __functor = _: hm;
}
