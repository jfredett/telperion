inputs@{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    <common/common.nix>
    <common/netbootable.nix>
    <common/vm-host.nix>
  ];

  environment.noXlibs = false;

  system.emerald-city.netbootable.enable = true;

  environment.systemPackages = with pkgs; [
    libvirt
    cmake
  ];

  networking.firewall.allowedTCPPorts = [ 22 5900 ];

  emerald-city.services.vm-host = {
    enable = true;
    backup_path = "/mnt/vm/${config.networking.hostName}";
    bridge_name = "ec-dmz-bridge";
  };
}

