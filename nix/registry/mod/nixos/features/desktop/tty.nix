/**
  TTY feature.

  kmscon console font configuration for better virtual console fonts.
*/
let
  mod =
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
    };
in
{
  __exports."nixos.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
