/**
  NixOS-integrated Home Manager for WSL.

  Configures albert's HM within NixOS using shared exports only.
*/
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
      imports = [
        exports.shared.hm.__module
      ] ++ imp.imports [
        registry.users.albert
      ];
    };
  };
}
