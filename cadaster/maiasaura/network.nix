{ config, pkgs, ... }: {
  networking.hostName = "maiasaura";

  services.openssh.enable = true;

  networking = {
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 ];
      interfaces = {
        enp60s0 = {
          allowedTCPPorts = [ 22 ];
        };
      };
    };

    useDHCP = false;

    interfaces = {
      wlp1s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "192.168.1.5";
            prefixLength = 24;
          }];
          routes = [
            { address = "192.168.1.0"; via = "192.168.1.1"; prefixLength = 24; }
          ];
        };
      };
    };

    narya.wireless = {
      enable = true;
      interface = "wlp1s0";
      dhcp = true;
    };
  };
}
