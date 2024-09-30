{ config, lib, ... }: {
  config = {
    services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
    hardware.nvidia = {
      nvidiaSettings = true;
      modesetting.enable = lib.mkDefault true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
}
