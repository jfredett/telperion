{ config, lib, pkgs, modulesPath, dns, root, laurelin, ... }: {
  imports = [
    # TODO: Should this be a module instead of an import?
    ../hardware/r730.nix
    ./network.nix
    ./storage.nix
    laurelin.nixosModules.netbootable
  ];

  config = {
    environment.noXlibs = false;

    telperion.infra.zfs.mode = "format";

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
