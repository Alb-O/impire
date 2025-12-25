# Swap devices for desktop
# Partition + file to ensure enough space for hibernation (RAM ~16G)
[
  { device = "/dev/disk/by-uuid/459d3fed-e5a3-4d17-ab68-fb2679849ea9"; }
  {
    device = "/var/swapfile";
    size = 16384;
  }
]
