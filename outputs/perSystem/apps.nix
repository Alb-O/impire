# VM app - launches the VM with QEMU
{ inputs, pkgs, ... }:
{
  vm = {
    type = "app";
    program = "${pkgs.writeShellScript "run-vm" ''
      # Build and run the VM
      exec nix run .#nixosConfigurations.vm.config.system.build.vm
    ''}";
  };
}
