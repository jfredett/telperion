{ config, pkgs, ... }:
{
  networking = { 
    hostName = "toto";



    #nftables.enable = true;

    defaultGateway = {
      address = "10.255.0.1";
      interface = "enp2s0";
    };

    vlans = {
      enp2s0_dns = {
        id = 1;
        interface = "enp2s0";
      };
    };

    firewall = {
      allowedTCPPorts = [ 22 ];
      interfaces.enp2s0.allowedTCPPorts = [ 22 53 ];
      interfaces."enp2s0_dns".allowedTCPPorts = [ 22 53 ];
    };

    useDHCP = false;
    interfaces = {
      enp2s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.1.9";
            prefixLength = 16;
          }];
        };
      };
      "enp2s0_dns" = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.0.3";
            prefixLength = 24;
          }];
        };
      };
      /*
      "enp2s0_110" = {
        useDHCP = false;
        ipv4 = { 
          addresses = [{
            address = "172.18.0.3";
            prefixLength = 24;
          }];
          routes = [
            { address = "172.18.0.0"; via = "172.18.0.1"; prefixLength = 24; }
          ];
        };
      };
      "enp2s0_120" = {
        useDHCP = false;
        ipv4 =  {
          addresses = [{
            address = "172.19.0.3";
            prefixLength = 24;
          }];
          routes = [
            { address = "172.19.0.0"; via = "172.19.0.1"; prefixLength = 24; }
          ];
        };
      };
      */
    };
  };

  narya.wireless = {
    enable = true;
    interface = "wlo2";
    dhcp = true;
  };
}
