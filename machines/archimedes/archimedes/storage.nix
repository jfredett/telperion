{ config, lib, pkgs, modulesPath, ... }: {
  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/3e7144d7-151e-4a20-abda-6bd8383bb075";
      fsType = "ext4";
    };

  fileSystems."/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/7900-2D1E";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/dc655f8a-ae5f-4017-afd9-1606ef1e65c2"; } ];
}
