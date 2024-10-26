{ config, lib, pkgs, root, laurelin, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/22c1a19d-d821-40e3-ad17-1d310d6c6fcf";
    fsType = "ext4";
  };

  fileSystems."swap" = {
    device = "/dev/disk/by-uuid/3f0e8a8b-ae5e-4e65-af71-e059232a5952";
    fsType = "swap";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = with pkgs; [
    turbovnc
  ];

  systemd.services."vnc-server" = {
    description = "VNC Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Enable = true;
      ExecStart = "${pkgs.turbovnc}/bin/vncserver :0";
      ExecStop = "${pkgs.turbovnc}/bin/vncserver -kill :0";
      User = "jfredett";
    };
  };

  networking.firewall.allowedTCPPorts = [ 5900 5901 5902 5903 ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
