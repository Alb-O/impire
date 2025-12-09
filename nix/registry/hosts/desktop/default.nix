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
    registry.mod.nixos.profiles.desktop
    # Merge layered configs: base → desktop-base → host-specific
    (imp.mergeConfigTrees [
      registry.hosts.shared.base.__path
      registry.hosts.shared.desktop-base.__path
      ./config
    ])
    inputs.home-manager.nixosModules.home-manager
    registry.roles.nixos.home-desktop
  ]
  ++ (imp.imports [
    # Specific desktop features (keyboard and niri are host-specific)
    registry.mod.nixos.features.desktop.keyboard
    registry.mod.nixos.features.desktop.niri
  ]);

  system.stateVersion = "24.11";
}
