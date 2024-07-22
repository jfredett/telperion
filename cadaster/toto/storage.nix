{ config, lib, pkgs, modulesPath, ... }: {

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/0b4f2c5f-ab60-44c3-9966-fc3d734ac785";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/782F-15FD";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
