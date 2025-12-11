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
      "shared.os"
      "desktop.nixos"
    ];
    hmSinks = [
      "shared.hm"
      "desktop.hm"
    ];
    modules = [
      "mod.os.features.desktop.keyboard"
      "mod.niri"
      "mod.os.features.desktop.netshare"
      "mod.os.features.desktop.tty"
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
