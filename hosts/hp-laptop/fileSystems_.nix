# Filesystem mounts for hp-laptop
{
  "/" = {
    device = "/dev/disk/by-uuid/f9eb6b74-5f28-4262-a0d3-3ef296eb2ad7";
    fsType = "ext4";
  };
  "/boot" = {
    device = "/dev/disk/by-uuid/2859-2E74";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
