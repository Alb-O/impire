# Fish shell feature - enables fish with direnv integration
# Absorbs autix aspects: env/default.nix (fish + direnv parts)
{ lib, ... }:
{
  programs.fish.enable = lib.mkDefault true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Disable bash - fish is the primary shell
  programs.bash.enable = lib.mkForce false;
}
