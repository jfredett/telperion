{ config, lib, pkgs, ... }: {
  networking.hostName = "archimedes"; # Define your hostname.

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
      enp60s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "10.255.1.1";
            prefixLength = 16;
          }];
        };
      };
      wlp61s0.useDHCP = true;
    };
  };

  narya.wireless = {
    enable = true;
    interface = "wlp61s0";
    dhcp = true;
  };
}
