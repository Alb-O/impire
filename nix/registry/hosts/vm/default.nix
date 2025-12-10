/**
  VM host - QEMU virtual machine for testing.

  Run with: nix run .#vm
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
    user = "albert";
  };

  config = ./config;

  extraConfig =
    { modulesPath, ... }:
    {
      imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];

      environment.etc."motd".text = ''

        ╔═══════════════════════════════════════════════════════════╗
        ║  impire NixOS Test VM                                     ║
        ║                                                           ║
        ║  User: albert (password: changeme)                        ║
        ║  Root password: changeme                                  ║
        ║  SSH: ssh -p 2222 albert@localhost                        ║
        ║  Config mounted at: /mnt/config                           ║
        ║                                                           ║
        ║  Rebuild: sudo nixos-rebuild test --flake /mnt/config     ║
        ╚═══════════════════════════════════════════════════════════╝

      '';
    };
}
