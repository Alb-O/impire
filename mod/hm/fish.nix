/**
  Fish shell feature.

  Fish with direnv integration.
*/
let
  mod =
    { lib, ... }:
    {
      programs.fish = {
        enable = lib.mkDefault true;
        shellAbbrs = {
          l = "lazygit";
          o = "opencode";
          y = "yazi";
        };
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.bash.enable = lib.mkForce false;
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
