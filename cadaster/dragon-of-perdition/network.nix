{ config, lib, pkgs, modulesPath, ... }: let

in {
  networking = {
    hostName = "dragon-of-perdition";
    dhcpcd.enable = false;

    nameservers = [ "172.19.0.3" ];

    defaultGateway = {
      address = "172.19.0.1";
      interface = "eno3";
    };

    firewall = {
      allowedTCPPorts = [ 22 ];
    };

    useDHCP = false;
    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "172.16.0.4";
            prefixLength = 24; # This corresponds to a subnet mask of 255.255.255.0
          }];
          routes = [
            { address = "172.16.0.0"; via = "172.16.0.1"; prefixLength = 24; }
          ];
        };
      };
      eno2 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "172.17.0.4";
            prefixLength = 24;
          }];
          routes = [
            { address = "172.17.0.0"; via = "172.17.0.1"; prefixLength = 24; }
          ];
        };
      };
      eno3 = {
        useDHCP = false;
        ipv4 = { 
          addresses = [{
            address = "172.19.0.4";
            prefixLength = 24;
          }];
          routes = [
            { address = "172.19.0.0"; via = "172.19.0.1"; prefixLength = 24; }
          ];
        };
      };
    };

    bridges = {
      ec-dmz-bridge = {
        interfaces = [ "eno4" ];
      };
    };

  };

}
