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
    inherit inputs imp registry exports;
  };

  modules = [
    registry.roles.hm.wsl
  ];
}
