inputs@{ config, pkgs, lib, modulesPath, laurelin, ... }: {
  environment.noXlibs = false;

  laurelin = {
    netbootable = true;
    mac = "90:8d:6e:c3:60:64";
    services.vm-host = {
      enable = true;
      backup_path = "/mnt/vm/${config.networking.hostName}";
      bridge_name = "ec-dmz-bridge";
      loadout = with laurelin.lib.vm; {
        domains = [
          (loadFromFile <emerald.city/domains/pinky.xml>)
          (loadFromFile <emerald.city/domains/barge.xml>)
        ];
        networks = [
          (loadFromFile <emerald.city/networks/ec-net.xml>)
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libvirt
    cmake
  ];

  networking.firewall.allowedTCPPorts = [ 22 5900 ];
}

