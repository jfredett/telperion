inputs@{ config, pkgs, lib, modulesPath, ... }: {
  environment.noXlibs = false;

  laurelin = {
    netbootable = true;
    mac = "90:8d:6e:c3:60:64";
  };

  environment.systemPackages = with pkgs; [
    libvirt
    cmake
  ];

  networking.firewall.allowedTCPPorts = [ 22 5900 ];

  /*
  emerald-city.services.vm-host = {
    enable = true;
    backup_path = "/mnt/vm/${config.networking.hostName}";
    bridge_name = "ec-dmz-bridge";
  };
  */
}

