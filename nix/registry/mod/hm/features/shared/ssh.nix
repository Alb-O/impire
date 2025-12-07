# SSH feature - SSH client configuration
{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      controlMaster = lib.mkDefault "auto";
      controlPersist = lib.mkDefault "10m";
      serverAliveInterval = lib.mkDefault 60;
      forwardAgent = lib.mkDefault true;
      extraOptions = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
