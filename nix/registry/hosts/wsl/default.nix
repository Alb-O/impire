/**
  WSL host - Windows Subsystem for Linux.
*/
{
  __inputs.nixos-wsl = {
    url = "github:nix-community/NixOS-WSL";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __host = {
    system = "x86_64-linux";
    stateVersion = "24.11";
    bases = [ "hosts.shared.base" ];
    sinks = [ "shared.os" ];
    hmSinks = [ "shared.hm" ];
    modules = [ "@nixos-wsl.nixosModules.default" ];
    user = "albert";
  };

  config = ./config;
}
