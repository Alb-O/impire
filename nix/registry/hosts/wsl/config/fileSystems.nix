# File systems for WSL
{ config, ... }:
{
  # NAS CIFS mount (raw, before catfs caching layer)
  "/home/albert/@/mount-raw" = {
    device = "//192.168.88.162/pivot share";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.secrets."nas/smb-credentials".path}"
      "uid=1001"
      "gid=100"
      "file_mode=0775"
      "dir_mode=0775"
      "vers=3.0"
      "sec=ntlmssp"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };
}
