# Desktop host entry point
# Albert's main workstation: AMD CPU, Nvidia GPU, Limine boot
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
      (modulesPath + "/installer/scan/not-detected.nix")
      # Merge layered configs: base → desktop-base → host-specific
      (imp.mergeConfigTrees [
        registry.hosts.shared.base.__path
        registry.hosts.shared.desktop-base.__path
        ./config
      ])
      inputs.home-manager.nixosModules.home-manager
      # Role-based exports: shared + desktop NixOS modules
      exports.shared.nixos.__module
      exports.desktop.nixos.__module
    ]
    ++ imp.imports [
      registry.roles.nixos.home-desktop
      # Specific desktop features (keyboard and niri are host-specific)
      registry.mod.nixos.features.desktop.keyboard
      registry.mod.nixos.features.desktop.niri
    ];

  system.stateVersion = "24.11";
}
