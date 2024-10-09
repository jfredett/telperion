{ config, root, laurelin, ... }: {
  imports = [
    # TODO: Should this be a module instead of an import?
    ../hardware/r730.nix
    ./network.nix
    ./storage.nix

    laurelin.nixosModules.netbootable
  ];

  config = {
    laurelin = {
      infra = {
        canon = "10.255.1.3";
        standard-packages.enable = true;
      };

      netboot = {
        netbootable = true;
        mac = "90:8d:6e:c3:60:64";
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
            ];
            networks = [
            ];
          };
        };
      };

      nfs = {
        "nancy.canon" = [
          {
            name = "vm";
            path = "/mnt/vm";
            host_path = "volume1";
            user = "root";
            group = "root";
            options = "defaults,hard,fg";
          }
        ];
      };
    };

    narya.users = {
      home-manager.enable = true;

      jfredett = {
        enable = true;
        mode = "dragon";
      };
      builder.enable = true;
    };
  };
}
