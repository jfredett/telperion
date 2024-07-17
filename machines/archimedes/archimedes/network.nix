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
            address = "172.19.0.14";
            prefixLength = 24;
          }];
          routes = [
            { address = "172.19.0.0"; via = "172.19.0.1"; prefixLength = 24; }
          ];
        };
      };
      wlp61s0.useDHCP = true;
    };

    wireless = {
      userControlled.enable = true;
      enable = true;
      interfaces = [ "wlp61s0" ];
      networks = {
        "Emerald City" = {
          # BUG: Hardcoded secret
          psk = "PASSWORD";
        };
      };
    };
  };
}
