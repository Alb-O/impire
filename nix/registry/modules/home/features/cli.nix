# CLI feature - common CLI tooling bundle
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
}
