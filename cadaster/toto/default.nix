{ config, lib, pkgs, root, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
  ];

  config = {
    narya.users = {
      jfredett = true;
      builder = true;
      media = false;
    };

    laurelin = {
      infra = {
        canon = "10.255.1.9";
        standard-packages.enable = true;
      };

      netboot = {
        enable = true;
        # TODO: Change the name, maybe move nfs config into here?
        image_path = "/mnt/emerald_city/netboot";
      };

      services = {
        dns = {
          enable = true;
          zones = root.genDNS.zones;
          interface = "enp2s0_dns";
        };
      };

      nfs = {
        "nancy.canon" = [
          {
            name = "emerald_city_netboot";
            path = config.laurelin.netboot.image_path;
            # FIXME: This abstraction is leaky, should be a lookup inside `network-storage.nix`.
            # Hardcoded to match whatever is on the target env. Nancy isn't nixified, so I can't
            # just pull it from her config... yet.
            host_path = "volume1";
          }
        ];
      };
    };
  };
}
