/**
  HP Laptop host - Albert's HP laptop.

  AMD CPU, laptop configuration.
*/
{
  __host = {
    system = "x86_64-linux";
    stateVersion = "24.11";
    bases = [
      "mod.base.base"
      "mod.base.desktop-base"
    ];
    sinks = [
      "shared.os"
      "desktop.nixos"
    ];
    hmSinks = [
      "shared.hm"
      "desktop.hm"
    ];
    modules =
      { registry, ... }:
      [
        registry.mod.dual.niri
      ];
    user = "albert";
  };

  config = ./.;

  extraConfig =
    { modulesPath, inputs, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.stylix.nixosModules.default
      ];
    };
}
