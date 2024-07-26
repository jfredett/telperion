{ config, lib, pkgs, modulesPath, ... }: let
in {
  networking = {
    hostName = "dragon-of-perdition";
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
        id = 10;
        interface = "bond";
      };
    };


    useDHCP = false;
    interfaces = {
      bond = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.1.3";
            prefixLength = 16;
          }];
        };
      };
    };

    bonds = {
      bond = {
        interfaces = [ "eno1" "eno2" "eno3" "eno4" ];
        driverOptions = {
          # https://www.kernel.org/doc/Documentation/networking/bonding.txt
          miimon = "10"; # Link monitoring frequency in ms
          mode = "active-backup"; # TODO: Explore other options
        };
      };
    };

    bridges = {
      ec-dmz-bridge = {
        interfaces = [ "bond_bridge" ];
      };
    };

  };

}
