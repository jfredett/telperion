# This machine expects a disk mounted at /mnt/local, and mounts NFS on /mnt/$name for each nfs
# mount. The former disk should be fast, local storage.

{ config, lib, pkgs, modulesPath, laurelin, narya, ... }: {
  imports = [ ./hardware.nix ];
  config = {
    boot.kernelModules = [ "tun" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

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

        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };

        prometheus.exporters = {
          nginx.enable = true;
        };

        docker = {
          host.enable = true;

          jellyfin = {
            enable = true;
            mediaRoot = "/mnt/Media";
          };

          dashy = {
            enable = true;
            conf = builtins.readFile ../../configs/dashy.yml;
          };

          grocy = {
            enable = true;
            configRoot = "/mnt/local";
          };

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

      users = {
        jfredett = {
          enable = true;
        };
      };
    };

    # BUG: This introduces a load order issue, it should be ref-by-id
    fileSystems."/mnt/local" = {
      device = "/dev/sda";
      fsType = "ext4";
    };

  };
}
