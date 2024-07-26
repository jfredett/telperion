{ config, lib, pkgs, modulesPath, dns, laurelin, ... }: {
  imports = [
     ./hardware.nix
     ./network.nix

    # FIXME: these rely on common modules from ereshkigal, so I'll need to swap them for laurelin
    # equivalents
    #./storage.nix
    ./config.nix
  ];

  config = {
    laurelin.infra = {
      canon = "10.255.1.3";
    };

    narya.users = {
      jfredett = true;
      builder = true;
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
  };
}
