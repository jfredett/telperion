{ config, lib, pkgs, root, laurelin, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {
    networking = {
      hostName = "randy";
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];
      useDHCP = false;
      interfaces = {
        ens3 = {
          useDHCP = false;
          ipv4 = {
            addresses = [{
              address = "10.255.1.22";
              prefixLength = 16;
            }];
          };
        };
      };
      defaultGateway = {
        address = "10.255.0.1";
        interface = "ens3";
      };
    };

    laurelin = {
      infra = {
        canon = "10.255.1.22";
        sound.enable = true;
        standard-packages.enable = true;
        remap-capslock.enable = true;
      };

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:22";
      };

      /*
      services = {
        _1password = {
          enable = true;
          withGUI = true;
        };
        window-manager = {
          enable = true;
          manager = "kde";
        };
      };
      */

      nfs = {
        "nancy.canon" = [
          {
            name = "emerald_city_netboot";
            path = "/mnt/emerald_city_netboot";
            host_path = "volume1";
          }
          { 
            name = "Lab";
            path = "/mnt/Lab";
            host_path = "volume1";
          }
          {
            name = "docker";
            path = "/mnt/docker";
            host_path = "volume1";
          }
          {
            name = "Media";
            path = "/mnt/Media";
            host_path = "volume1";
          }
        ];
      };
    };

    narya.users = {
      home-manager.enable = false;
      jfredett = true;
    };

    fileSystems."/" = { device = "tmpfs"; fsType = "tmpfs"; options = [ "size=16G" ]; };
  };
}
