{ config, lib, pkgs, root, laurelin, ... }: {
  networking = {
    hostName = "randy";
    domain = "emerald.city";
    nameservers = [ "10.255.0.3" ];
    useDHCP = false;
    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.1.22";
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
  }
