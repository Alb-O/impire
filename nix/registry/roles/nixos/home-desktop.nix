# NixOS helper: Home Manager setup for desktop/VM hosts
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
        registry.mod.hm.profiles.desktop
      ];
    };
  };
}
