# Desktop host entry point
# Albert's main workstation: AMD CPU, Nvidia GPU, Limine boot
{
  imp,
  inputs,
  registry,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Merge layered configs: base → desktop-base → host-specific
    # Demonstrates mergeConfigTrees layering pattern
    (imp.mergeConfigTrees [
      registry.hosts.shared.base.__path # All hosts: time, base user
      registry.hosts.shared.desktop-base.__path # Desktop hosts: audio/video groups
      ./config # Host-specific: extra groups, hardware, etc
    ])
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ (imp.imports [
    # Specific desktop features (keyboard and niri are host-specific)
    registry.modules.nixos.features.desktop.keyboard
    registry.modules.nixos.features.desktop.niri
  ]);

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.albert = import registry.users.albert;
  };

  system.stateVersion = "24.11";
}
