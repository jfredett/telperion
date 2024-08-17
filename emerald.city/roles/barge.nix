# This machine expects a disk mounted at /mnt/local, and mounts NFS on /mnt/$name for each nfs
# mount. The former disk should be fast, local storage.

{ config, lib, pkgs, laurelin, narya, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {
    boot.kernelModules = [ "tun" ];

    networking = {
      hostName = "barge";
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];
      firewall.allowedTCPPorts = [ 80 443 ];
      useDHCP = false;
      interfaces = {
        ens3 = {
          useDHCP = false;
          ipv4 = {
            addresses = [{
              address = "10.255.1.70";
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
        canon = "10.255.1.70";
      };

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:00";
      };

      nfs = {
        "nancy.canon" = [
          {
            name = "Lab";
            path = "/mnt/Lab";
            host_path = "volume1";
          }
          {
            name = "Media";
            path = "/mnt/Media";
            host_path = "volume1";
          }
        ];
      };

      services = {
        reverse-proxy = {
          enable = true;
          fqdn.port = 8001;
        };

        docker = {
          host.enable = true;

          jellyfin = {
            enable = true;
            mediaRoot = "/mnt/Media";
          };

          dashy.enable = true;
          gluetun.enable = true;
        };
      };
    };

    narya = {
      services.docker = {
        host = {
          enable = true;
          enableDefaults = true;
        };
      };

      users.jfredett = true;
    };

    fileSystems."/mnt/local" = {
      device = "/dev/sda";
      fsType = "ext4";
    };

  };
}
