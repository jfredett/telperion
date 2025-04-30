{ narya, ... }: let 
  disks = narya.infra.disks.dragon-of-perdition;
in with disks.lib; {
  fileSystems."/storage" = {
    device = disk "nvme-0";
    fsType = "ext4";
  };

  fileSystems."/" = {
    device = disk "sda";
    fsType = "ext4";
  };
}
