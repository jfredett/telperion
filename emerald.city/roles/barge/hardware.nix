{ config, lib, pkgs, root, laurelin, modulesPath, ... }: let 
  kernelPkg = pkgs.linuxPackages_6_6;
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.kernelPackages = kernelPkg;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "umask=0022" "uid=0" "gid=0" ];
  };



  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.intel-compute-runtime ];
  };
 
  nixpkgs.config = {
    allowUnfree = true;
  };

  networking.firewall.allowedTCPPorts = [ 5901 ];
}
