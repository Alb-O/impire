# Standalone Home Manager configuration for albert on desktop
# Switch with: home-manager switch --flake .#albert-desktop
{
  inputs,
  imp,
  registry,
  nixpkgs,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  extraSpecialArgs = {
    inherit inputs imp registry;
  };

  modules = [
    registry.users.albert
    registry.mod.hm.base
  ];
}
