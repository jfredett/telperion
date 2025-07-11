{ config, lib, pkgs, root, laurelin, narya, ... }: {
  imports = [
    ./hardware.nix
  ];

  config = {
    networking = {
      firewall.allowedTCPPorts = [ 22 80 443 6443 ];
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];

      useDHCP = false;
      hostName = "odysseus-01";
      interfaces = {
        ens3 = {
          useDHCP = false;
          ipv4 = {
            addresses = [{
              address = "10.255.1.10";
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
        canon = "10.255.1.10";
      };


      nfs = {
        "nancy.canon" = [
          # {
          #   name = "prometheus-data";
          #   path = "/var/lib/prometheus-data";
          #   user = "prometheus";
          #   group = "prometheus";
          #   host_path = "volume1";
          #   options = "";
          # }
        ];
      };

      services = {
        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };

        k3s = {
          enable = true;
          nfs = {
            enable = true;
            host = "nancy.canon";
          };
          role = "server";
        };
      };
    };

    narya = {
      trusted-certificates.enable = true;
      users = {
        jfredett = {
          enable = true;
        };
      };
    };
  };
}
