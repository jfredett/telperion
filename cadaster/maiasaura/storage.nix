
{ config, pkgs, ... }: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2b54ac0c-93ef-4ecb-bc83-845984406df3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5A2C-A7BA";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/df7d20fe-27cb-4167-b309-4ad1a980399c"; }
  ];
}
