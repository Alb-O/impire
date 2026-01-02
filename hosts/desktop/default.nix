/**
  Desktop host - Albert's main workstation.

  AMD CPU, Nvidia GPU 🤢, Limine boot.
*/
{
  __host = {
    system = "x86_64-linux";
    stateVersion = "24.11";

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
        registry.mod.os.keyboard
        registry.mod.dual.niri
        registry.mod.os.netshare
        registry.mod.os.tty
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
