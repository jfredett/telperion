{ config, lib, pkgs, root, laurelin, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
  ];

  config = {

    laurelin = {
      infra = {
        canon = "10.255.1.22";
        sound.enable = true;
        standard-packages.enable = true;
        remap-capslock.enable = true;
      };

      services = {
        _1password = {
          enable = true;
          withGUI = true;
        };
        window-manager = {
          enable = true;
          manager = "hyprland";
        };
#        rustdesk.client.enable = true;
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
        # FIXME: To be clear, this is evil magic. I'm sorry. I don't want to have hyprland enabled
        # everywhere just yet.
        extraConfig = {
          glamdring.hyprland.enable = true;
        };
      };
      jfredett = true;
    };
  };
}
