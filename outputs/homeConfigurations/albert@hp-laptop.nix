# Standalone HM config for hp-laptop - home-manager switch --flake .#albert@hp-laptop
{
  inputs,
  imp,
  registry,
  exports,
  nixpkgs,
  ...
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  extraSpecialArgs = {
    inherit
      inputs
      imp
      registry
      exports
      ;
  };

  modules = [
    inputs.stylix.homeManagerModules.stylix
    exports.shared.hm.__module
    exports.desktop.hm.__module
  ] ++ imp.imports [ registry.users.albert ];
}
