{ config, lib, pkgs, modulesPath, dns, root, laurelin, ... }: {
  imports = [
    # TODO: Should this be a module instead of an import?
    ../hardware/r730.nix
    ../hardware/nvidia/p40.nix
    ./network.nix
    ./storage.nix
    laurelin.nixosModules.netbootable
  ];

  config = {
    environment.noXlibs = false;

    telperion.infra.zfs.mode = "mount";

    narya.users = {
      passwordLogin = false;
      jfredett = true;
      builder = true;
    };

    laurelin = {
      infra = {
        canon = "10.255.1.4";
        standard-packages.enable = true;
      };

      netboot = {
        netbootable = true;
        mac = "74:86:7a:e4:0e:74";
      };

      services = {
        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };
        prometheus.exporters = {
          node = {
            enable = true;
            domain = "canon";
          };
          systemd = {
            enable = true;
            domain = "canon";
          };
        };

        vm-host = {
          enable = true;
          backup_path = "/mnt/vm/${config.networking.hostName}";
          bridge_name = "ec-dmz-bridge";
          loadout = with laurelin.lib.vm; with root.domains."emerald.city"; {
            domains = [
              (loadFromFile domains.pinky)
              (loadFromFile domains.barge)
              (loadFromFile domains.randy)
              (loadFromFile domains.daktylos)
            ];
            networks = [
              (loadFromFile networks.ec-net)
            ];
            pools = [
              { definition = laurelin.lib.vm.pool.writeXML {
                  name = "vm-pool";
                  uuid = "e6d4eb84-e0e0-4ac8-89b4-f2bd1379af8e";
                  type = "dir";
                  target = { path = "/mnt/tank/vm"; };
                };
                active = true;
                volumes = [
                  {
                    definition = laurelin.lib.vm.volume.writeXML {
                      name = "daktylos_disk";
                      capacity = { count = 250; unit = "GiB"; };
                    };
                  }
                  {
                    definition = laurelin.lib.vm.volume.writeXML {
                      name = "randy_disk";
                      capacity = { count = 1; unit = "TiB"; };
                    };
                  }
                  {
                    definition = laurelin.lib.vm.volume.writeXML {
                      name = "barge_disk";
                      capacity = { count = 1; unit = "TiB"; };
                    };
                  }
                  {
                    definition = laurelin.lib.vm.volume.writeXML {
                      name = "pinky_test";
                      capacity = { count = 10; unit = "GiB"; };
                    };
                  }
                ];
              }
            ];
          };
        };
      };

      nfs = {
        "nancy.canon" = [
          {
            name = "vm";
            path = "/mnt/nancy/vm";
            host_path = "volume1";
            user = "root";
            group = "root";
            options = "defaults,hard,fg";
          }
        ];
      };
    };
  };
}
