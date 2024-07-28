{ config, lib, pkgs, modulesPath, dns, root, laurelin, ... }: {
  imports = [
     ./hardware.nix
     ./network.nix

    # FIXME: these rely on common modules from ereshkigal, so I'll need to swap them for laurelin
    # equivalents
    #./storage.nix

    laurelin.nixosModules.netbootable
  ];

  config = {
    environment.noXlibs = false;

    narya.users = {
      jfredett = true;
      builder = true;
    };

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
        vm-host = {
          enable = true;
          backup_path = "/mnt/vm/${config.networking.hostName}";
          bridge_name = "ec-dmz-bridge";
          loadout = with laurelin.lib.vm; with root.domains."emerald.city"; {
            domains = [
              (loadFromFile domains.pinky)
            ];
            networks = [
              (loadFromFile networks.ec-net)
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

    environment.systemPackages = with pkgs; [
      libvirt
      cmake
    ];

    networking.firewall.allowedTCPPorts = [ 22 5900 ];
  };
}
