# NixOS helper: Home Manager setup for WSL host
{
  inputs,
  imp,
  registry,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs imp registry; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.albert = {
      imports = imp.imports [
        registry.users.albert
      ];
    };
  };
}
