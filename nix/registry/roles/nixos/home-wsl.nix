# NixOS helper: Home Manager setup for WSL host
{
  inputs,
  exports,
  imp,
  registry,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs exports imp registry; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.albert = {
      imports = imp.imports [
        registry.users.albert
        registry.mod.hm.profiles.shared
      ];
    };
  };
}
