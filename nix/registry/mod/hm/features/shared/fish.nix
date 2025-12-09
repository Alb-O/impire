/**
  Fish shell feature.

  Fish with direnv integration.
*/
let
  mod =
    { lib, ... }:
    {
      programs.fish.enable = lib.mkDefault true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.bash.enable = lib.mkForce false;
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
