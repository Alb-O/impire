# WSL host entry point
# Albert's Windows Subsystem for Linux configuration
{
  imp,
  inputs,
  registry,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    (imp.configTree ./config)
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs imp registry; };
    users.albert = import registry.users.albert;
  };

  system.stateVersion = "24.11";
}
