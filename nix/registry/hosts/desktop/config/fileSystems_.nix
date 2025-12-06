# Filesystem mounts for desktop
{
  "/" = {
    device = "/dev/disk/by-uuid/63e07791-3c10-422d-b6c6-531addc58e46";
    fsType = "ext4";
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/AA74-E6F5";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
}
