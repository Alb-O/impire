/**
  VM host entry point.

  Run with: nix run .#vm
*/
{
  imp,
  inputs,
  exports,
  registry,
  modulesPath,
  ...
}:
{
  imports =
    [
      (modulesPath + "/virtualisation/qemu-vm.nix")
      (imp.mergeConfigTrees [
        registry.hosts.shared.base.__path
        registry.hosts.shared.desktop-base.__path
        ./config
      ])
      inputs.home-manager.nixosModules.home-manager
      exports.shared.nixos.__module
      exports.desktop.nixos.__module
    ]
    ++ imp.imports [
      registry.roles.nixos.home-desktop
    ];

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

  system.stateVersion = "24.11";
}
