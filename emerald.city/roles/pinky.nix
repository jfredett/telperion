{ config, lib, pkgs, root, laurelin, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {
    networking = {
      hostName = "pinky";
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];
      useDHCP = false;
      interfaces = {
        ens3 = {
          useDHCP = false;
          ipv4 = {
            addresses = [{
              address = "10.255.1.69";
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
        canon = "10.255.1.69";
      };

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:69";
      };

      services = {
        dns = {
          enable = true;
          zones = root.genDNS.zones;
          interface = "ens3";
        };

        prometheus.exporters = {
          node = {
            enable = true;
          };

          systemd = {
            enable = true;
          };
        };
      };
    };

    narya.users = {
      passwordLogin = true;
      jfredett = true;
    };
  };
}
