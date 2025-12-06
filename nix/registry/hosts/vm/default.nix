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
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.albert = import registry.users.albert;
  };

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
