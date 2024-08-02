{ config, pkgs, ... }: {
  networking.hostName = "maiasaura";

  services.openssh.enable = true;

  networking = {
    nftables.enable = true;

    firewall = {
      allowedTCPPorts = [ 22 ];
    };

    nameservers = [ "10.255.0.3" ];

    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlp1s0";
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
        };
      };
    };
  };

  narya.wireless = {
    enable = true;
    interface = "wlp1s0";
    dhcp = false;
  };
}
