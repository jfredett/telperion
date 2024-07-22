{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
    ./config.nix # Temporary additional config
  ];

  config = {
    laurelin.infra = {
      canon = "10.255.1.9";
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
