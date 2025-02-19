{ config, lib, pkgs, modulesPath, dns, laurelin, glamdring, home-manager, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
  ];

  config = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    laurelin = {
      infra = {
        canon = "10.255.1.1";
        sound.enable = true;
        standard-packages.enable = true;
        remap-capslock.enable = true;
      };

      services = {
        _1password = {
          enable = true;
          withGUI = true;
        };
        virtualbox = {
          enable = false;
          users = [ "jfredett" ];
        };
        window-manager = {
          enable = true;
          manager = "kde";
          /*
          hyprland = {
            gpu = "nvidia";
          };
          */
        };
        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };
        prometheus.exporters = {
          node = {
            enable = true;
            domain = "canon";
          };
          systemd = {
            enable = true;
            domain = "canon";
          };
        };
      };

      nfs = {
        "nancy.canon" = [
          {
            name = "emerald_city_netboot";
            path = "/mnt/emerald_city_netboot";
            host_path = "volume1";
          }
          { 
            name = "Lab";
            path = "/mnt/Lab";
            host_path = "volume1";
          }
          {
            name = "docker-private";
            path = "/mnt/docker-private";
            host_path = "volume1";
          }
          {
            name = "docker";
            path = "/mnt/docker";
            host_path = "volume1";
          }
          {
            name = "Media";
            path = "/mnt/Media";
            host_path = "volume1";
          }
        ];
      };
    };


    narya.users = {
      home-manager = {
        enable = true;
      };

      jfredett = {
        enable = true;
        mode = "standard";
      };

      builder.enable = true;
    };
  };
}
