# VM host entry point
# Run with: nix run .#vm
{
  imp,
  inputs,
  registry,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
    registry.mod.nixos.profiles.desktop
    # Merge layered configs: base → desktop-base → host-specific
    (imp.mergeConfigTrees [
      registry.hosts.shared.base.__path # All hosts: time, base user
      registry.hosts.shared.desktop-base.__path # Desktop hosts: audio/video groups
      ./config # VM-specific: root user, services, etc
    ])
    inputs.home-manager.nixosModules.home-manager
    registry.hosts.vm.home
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
