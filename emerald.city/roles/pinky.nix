{ config, lib, pkgs, laurelin, ... }: {
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
    };

    narya.users = {
      jfredett = true;
    };
  };
}