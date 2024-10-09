{ config, pkgs, lib, glamdring, ... }: {
  imports = [ 
    ./hardware.nix
    ./network.nix
    ./storage.nix
  ];

  config = {

    laurelin = {
      infra = {
     #   canon = "10.255.1.2";
        # TODO: This is the wifi interface, I haven't flattened the networks yet, so this lives
        # 'outside' the normal canon network, but I still want it to have a canon address. Thus a
        # compromise
        canon = "192.168.1.5";
        sound.enable = true;
        standard-packages.enable = true;
      };

      services = {
        window-manager = {
          enable = true;
          manager = "kde";
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
    };

    narya.users = {
      home-manager.enable = true;
      jfredett = {
        enable = true;
        mode = "standard";
      };
      media = {
        enable = true;
        mode = "media";
      };
      builder.enable = true;
    };
  };
}
