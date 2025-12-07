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
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ (imp.imports [
    registry.modules.nixos.features.desktop.desktop
    registry.modules.nixos.features.desktop.keyboard
    registry.modules.nixos.features.desktop.niri
    registry.modules.nixos.features.desktop.wayland
  ]);

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.albert = import registry.users.albert;
  };

  system.stateVersion = "24.11";
}
