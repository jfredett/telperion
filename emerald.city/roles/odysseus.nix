# This machine expects a disk mounted at /mnt/local, and mounts NFS on /mnt/$name for each nfs
# mount. The former disk should be fast, local storage.

{ config, lib, pkgs, root, laurelin, narya, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {



    #networking.firewall.allowedTCPPorts = [
      # Set below: 6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    #];
    #networking.firewall.allowedUDPPorts = [
    #  # 8472 # k3s, flannel: required if using multi-node for inter-node networking
    #];
    services.k3s.enable = true;
    services.k3s.role = "server";
    #services.k3s.extraFlags = toString [
    #  # "--debug" # Optionally add additional args to k3s
    #];



    networking = {
      hostName = "odysseus";
      domain = "emerald.city";
      nameservers = [ "10.255.0.3" ];
      firewall.allowedTCPPorts = [ 80 443 6443 ];
      useDHCP = false;
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

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:10";
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

      };
    };


    narya.users = {
      jfredett = {
        enable = true;
      };
    };
  };
}
