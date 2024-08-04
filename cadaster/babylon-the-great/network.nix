{ config, lib, pkgs, modulesPath, ... }: let
in {
  networking = {
    hostName = "babylon-the-great";
    dhcpcd.enable = false;

    nameservers = [ "10.255.0.3" ];

    defaultGateway = {
      address = "10.255.0.1";
      interface = "bond";
    };

    firewall = {
      allowedTCPPorts = [ 22 ];
    };

    vlans = {
      bond_bridge = {
        id = 1; # TODO: Actually set this up for real, the switch needs adjusting
        interface = "bond";
      };
    };

    useDHCP = false;
    interfaces = {
      bond = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.1.4";
            prefixLength = 16;
          }];
        };
      };
    };

    bonds = {
      bond = {
        interfaces = [ "eno1" "eno2" "eno3" ];
        driverOptions = {
          # https://www.kernel.org/doc/Documentation/networking/bonding.txt
          miimon = "10"; # Link monitoring frequency in ms
          mode = "active-backup"; # TODO: Explore other options
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
