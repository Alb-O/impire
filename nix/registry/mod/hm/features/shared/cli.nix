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
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
