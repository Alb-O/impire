# Systemd services for WSL
{ pkgs, ... }:
{
  # catfs: FUSE caching layer for NAS mount
  # Caches reads locally so ripgrep doesn't hammer the NAS every time
  # Architecture: /home/albert/@/mount-raw (CIFS) -> catfs -> /home/albert/@/mount (cached)
  services.catfs-nas = {
    description = "catfs cache for NAS";
    after = [
      "network-online.target"
      "home-albert-\\x40-mount\\x2draw.mount" # systemd-escaped mount unit name
    ];
    wants = [ "network-online.target" ];
    requires = [ "home-albert-\\x40-mount\\x2draw.mount" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      # --free=10%: evict cache when disk drops below 10% free
      # Cache stored in /var/cache/catfs-nas
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/cache/catfs-nas /home/albert/@/mount";
      ExecStart = "${pkgs.catfs}/bin/catfs --free=10% /var/cache/catfs-nas /home/albert/@/mount-raw /home/albert/@/mount";
      ExecStop = "/run/wrappers/bin/fusermount -u /home/albert/@/mount";
      Restart = "on-failure";
      User = "albert";
      Group = "users";
    };
  };
}
