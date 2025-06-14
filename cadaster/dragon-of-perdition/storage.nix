{ narya, ... }: let
  disks = narya.infra.disks.dragon-of-perdition;
in with disks.lib; {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/699E-A832";
      fsType = "vfat";
      options = [ "umask=0022" "uid=0" "gid=0" ];
    };
}
