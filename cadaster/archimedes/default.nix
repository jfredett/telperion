{ config, lib, pkgs, modulesPath, dns, laurelin, glamdring, home-manager, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
  ];

  config = {
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
          enable = true;
          users = [ "jfredett" ];
        };
        window-manager = {
          enable = true;
          manager = "lxqt";
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

    # TODO: move this into the users module in narya.
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.jfredett = glamdring.homeConfigurations.jfredett;
    };

    narya.users = {
      jfredett = true;
      builder = true;
    };

  };
}
