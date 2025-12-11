/**
  SSH feature.

  SSH client and server configuration.
  HM: SSH client configuration with connection multiplexing and agent forwarding
  OS: OpenSSH server with hardened defaults
*/
let
  hm =
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
    };
  os =
    { lib, ... }:
    {
      services.openssh = {
        enable = lib.mkDefault true;
        settings = {
          PermitRootLogin = lib.mkDefault "no";
          PasswordAuthentication = lib.mkDefault false;
        };
      };
    };
in
{
  __exports.shared.hm.value = hm;
  __exports.shared.os.value = os;
  __module = hm;
  __functor = _: hm;
}
