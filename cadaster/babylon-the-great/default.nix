{ config, lib, pkgs, modulesPath, dns, laurelin, ... }: {
  imports = [
     ./hardware.nix
     ./network.nix

    # FIXME: these rely on common modules from ereshkigal, so I'll need to swap them for laurelin
    # equivalents
    #./storage.nix
    #./config.nix
  ];

  config = {
    laurelin.infra = {
      canon = "10.255.1.4";
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

    nixpkgs.config.allowUnfree = true;

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.lxqt.enable = true;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
