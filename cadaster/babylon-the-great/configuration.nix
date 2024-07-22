{ config, pkgs, lib, modulesPath, ... }: let 
  build = config.system.build;
  kernelTarget = pkgs.stdenv.hostPlatform.linux-kernel.target;
in {
  imports = [
    ./hardware-configuration.nix

    (modulesPath + "/installer/netboot/netboot-minimal.nix")

    <common/common.nix>
  ];

  environment.noXlibs = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "babylon-the-great";

  environment.systemPackages = with pkgs; [
    libvirt
    cmake
  ];

  security.polkit.enable = true;
  security.polkit.debug = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "virbr1"
      "ec-dmz-bridge"
    ];
  };

  networking.bridges = {
    ec-dmz-bridge = {
      interfaces = [ "eno4" ];
    };
  };

  system.build.netboot = pkgs.runCommand "netboot" { } ''
  mkdir -p $out

  ln -s ${build.kernel}/${kernelTarget}         $out/${kernelTarget}
  ln -s ${build.netbootRamdisk}/initrd          $out/initrd
  ln -s ${build.netbootIpxeScript}/netboot.ipxe $out/ipxe
  '';
}

