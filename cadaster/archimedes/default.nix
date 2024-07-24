{ config, lib, pkgs, modulesPath, dns, laurelin, glamdring, home-manager, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
    ./config.nix

  ];

  config = {
    laurelin.infra = {
      canon = "10.255.1.1";
    };

    nix = {
      package = pkgs.nixFlakes;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    laurelin.nfs = {
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

    nixpkgs.config.allowUnfree = true;

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.lxqt.enable = true;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
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
