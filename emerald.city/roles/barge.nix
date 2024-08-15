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
            name = "docker";
            path = "/mnt/docker";
            host_path = "volume1";
          }
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
    };

    # TODO: Rev Proxy to another machine/cluster?
    services.nginx = {
      enable = true;

      clientMaxBodySize = "25m";

      virtualHosts = {
        "${config.networking.fqdn}" = {
          serverName = "${config.networking.fqdn}";
          locations."/" = {
            proxyPass = "http://127.0.0.1:8001";
            recommendedProxySettings = true;
          };
        };

        "jellyfin.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            recommendedProxySettings = true;
          };
        };

        "radarr.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:7878";
            recommendedProxySettings = true;
          };
        };

        "sonarr.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8989";
            recommendedProxySettings = true;
          };
        };

        "lidarr.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8686";
            recommendedProxySettings = true;
          };
        };

        "bazarr.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:6767";
            recommendedProxySettings = true;
          };
        };

        "torrent.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            recommendedProxySettings = true;
          };
        };

        "dashy.emerald.city" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8001";
            recommendedProxySettings = true;
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /mnt/docker/jellyfin 0755 root users -"
      "d /mnt/docker/radarr 0755 root users -"
      "d /mnt/docker/sonarr 0755 root users -"
      "d /mnt/docker/lidarr 0755 root users -"
      "d /mnt/docker/bazarr 0755 root users -"
      "d /mnt/docker/emerald-city-torrent 0755 root users -"
      "d /mnt/local/emerald-city-torrent 0755 root users -"
      "d /mnt/docker/dashy 0755 root users -"
      "d /mnt/tmp 0755 root users -"
      "d /mnt/local/gluetun 0755 root users -"
    ];

    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    virtualisation.oci-containers = {
      backend = "podman";
      containers = narya.infra.docker.barge // {
        gluetun = {
          image = "qmcgaw/gluetun";
          ports = [
            "8888:8888"
            "8080:8080"
            "8081:8081"
            "6881:6881"
            "6881:6881/udp"
            "6882:6882"
            "6882:6882/udp"
          ];
          volumes = [ "/mnt/local/gluetun:/gluetun:rw" ];
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--device=/dev/net/tun"
          ];
          environment = {
            VPN_SERVICE_PROVIDER = "protonvpn";
            VPN_TYPE = "openvpn";
            # FIXME: turnkey, my dude.
            OPENVPN_USER = narya.infra.vpn.protonvpn.openvpn.creds.user;
            OPENVPN_PASSWORD = narya.infra.vpn.protonvpn.openvpn.creds.password;
            SERVER_COUNTRIES = narya.infra.vpn.protonvpn.server-countries;
          };
        };


        jellyfin = {
          image = "jellyfin/jellyfin";
          ports = [ "8096:8096" ];
          volumes = [
            "/mnt/docker/jellyfin:/config:rw"
            "/mnt/Media:/media:rw"
          ];
        };

        dashy = {
          image = "lissy93/dashy";
          ports = [ "8001:8080" ];
          volumes = [ 
            "/mnt/docker/dashy:/app/user-data:rw"
          ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    fileSystems."/mnt/local" = {
      device = "/dev/sda";
      fsType = "ext4";
    };

    narya.users = {
      jfredett = true;
    };
  };
}

