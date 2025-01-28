{ config, lib, pkgs, root, laurelin, modulesPath, ... }: let 
  kernelPkg = pkgs.linuxPackages_6_6;
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ 
      "ata_piix" "uhci_hcd" "sd_mod"
      "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelPackages = kernelPkg;

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
    extraPackages = [ pkgs.intel-compute-runtime ];
  };
 
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = with pkgs; [
    turbovnc
    nvtopPackages.full
    hashcat
    pciutils
    cudatoolkit
  ];

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  /*
  systemd.services."vnc-server" = {
    description = "VNC Server";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.turbovnc ];
    environment.DISPLAY = ":1";
    serviceConfig = {
      Type = "simple";
      Enable = true;
      ExecStart = pkgs.writeShellScript "start-vnc-server.sh" ''
        # HACK: This presumes kde is installed and the current-system has this available, but for the moment that should
        # be true.
        ${pkgs.turbovnc}/bin/vncserver -fg -xstartup /run/current-system/sw/bin/startplasma-x11 $DISPLAY
      '';
      ExecStop = "${pkgs.turbovnc}/bin/vncserver -kill :1";
      User = "jfredett";
    };
  };
  */

  networking.firewall.allowedTCPPorts = [ 5901 ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
