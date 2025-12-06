# TTY feature - kmscon console font configuration
# Provides better fonts for virtual consoles
{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "JetBrains Mono NL";
        package = pkgs.jetbrains-mono;
      }
    ];
    extraConfig = "font-size=18";
  };
}
