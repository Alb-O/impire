/**
  Desktop host - Albert's main workstation.

  AMD CPU, Nvidia GPU, Limine boot.
*/
{
  __host = {
    system = "x86_64-linux";
    stateVersion = "24.11";
    bases = [
      "hosts.shared.base"
      "hosts.shared.desktop-base"
    ];
    sinks = [
      "shared.nixos"
      "desktop.nixos"
    ];
    hmSinks = [
      "shared.hm"
      "desktop.hm"
    ];
    modules = [
      "mod.nixos.features.desktop.keyboard"
      "mod.nixos.features.desktop.niri"
      "mod.nixos.features.desktop.netshare"
      "mod.nixos.features.desktop.tty"
    ];
    user = "albert";
  };

  config = ./config;

  extraConfig =
    { modulesPath, ... }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    };
}
