/**
  CLI feature.

  Common CLI tooling bundle.
*/
let
  mod =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atuin
        eza
        fd
        ffmpeg
        gh
        onefetch
        poppler-utils
        ripgrep
        unzip
        yt-dlp
      ];
    };
in
{
  __exports."shared.hm".value = mod;
  __module = mod;
  __functor = _: mod;
}
