# This machine expects a disk mounted at /mnt/local, and mounts NFS on /mnt/$name for each nfs
# mount. The former disk should be fast, local storage.

{ config, lib, pkgs, root, laurelin, narya, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {
    boot.kernelModules = [ "tun" ];

    networking = {
      hostName = "daktylos";
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];
      firewall.allowedTCPPorts = [ 80 443 ];
      useDHCP = false;
      interfaces = {
        ens3 = {
          useDHCP = false;
          ipv4 = {
            addresses = [{
              address = "10.255.1.50";
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
        canon = "10.255.1.50";
      };

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:50";
      };

      /*
      nfs = {
        "nancy.canon" = [
        ];
      };
      */

      services = {
        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };

        reverse-proxy = {
          enable = true;
          fqdn.port = 8001;
          services = {
            "grafana" = { port = 3000; proxyWebsockets = true; };
            "prometheus" = { port = 9090; };
            "loki" = { port = 3100; };
          };
        };

        grafana = {
          enable = true;
          domain = "emerald.city";
          dashboards = with laurelin.lib; let
            dashFor = host: id: (mkDashboard {
              templateName = "system-view-template";
              dashboardName = "system-view-${host}";
              args = {
                inherit id;
                hostname = "${host}";
              };
            });
          in [
            (dashFor "barge" 1)
            (dashFor "daktylos" 2)
            (dashFor "archimedes" 3)
            (dashFor "babylon-the-great" 4)
            (dashFor "dragon-of-perdition" 5)
            (dashFor "maiasaura" 6)
            (dashFor "toto" 7)
          ];
        };

        prometheus = {
          host = {
            enable = true;
            scrapeConfigs = root.scrapeTargets ++ [
              {
                job_name = "emerald-city-torrent";
                static_configs = [
                  {
                    labels = {
                      hostname = "barge";
                    };
                    targets = [
                      "barge.emerald.city:8079"
                    ];
                  }
                ];
              }
            ];
          };
          exporters = {
            node = {
              enable = true;
              # TODO: Extract defaultDomain somehow?
              domain = "emerald.city";
            };

            systemd = {
              enable = true;
              domain = "emerald.city";
            };

            nginx.enable = true;
          };
        };
      };
    };

    narya = {
      users.jfredett = true;
    };

    fileSystems."/mnt/local" = {
      device = "/dev/sda";
      fsType = "ext4";
    };

    # Prometheus
    services = {
      loki = {
        enable = true;
        configFile = ../configs/loki.yml;
      };
    };

    # Alertmanager
    #   - Maybe with the webhook thing?
    #   - this would be helpful for alerting on non-disaster events, e.g., if brocard ever finds
    #   something, when long running tasks finish, etc.
    # Push Gateway (Arbitrary input of metrics)
    # Tempo? (Distributed Traces)
    # blackbox exporter
    # node exporter

    # VictoriaMetrics? (Faster Prom backend)
    # Thanos/Cortex (scaling prom + long term storage)

    # I think I want ~1mo of logs and metrics, ideally, or maybe like 200GB, whichever comes first.


  };
}
