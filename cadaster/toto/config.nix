{ config, pkgs, ... }:
{

  narya.users = {
    jfredett = true;
    builder = true;
    media = false;
  };

  laurelin.netboot = {
    enable = true;
    # TODO: Change the name, maybe move nfs config into here?
    image_path = "/mnt/emerald_city/netboot";
  };

  laurelin.nfs = {
    "nancy.canon" = [
      {
          name = "emerald_city_netboot";
          path = config.laurelin.netboot.image_path;
          # FIXME: This abstraction is leaky, should be a lookup inside `network-storage.nix`.
          # Hardcoded to match whatever is on the target env. Nancy isn't nixified, so I can't
          # just pull it from her config.
          host_path = "volume1";
      }
    ];
  };

  # TODO: This should be wrapped in a 'standard packages' module that is default enabled, but 
  # can be turned off
  environment.systemPackages = with pkgs; [
    neovim
    python3
    wget
    lsof
  ];
}

