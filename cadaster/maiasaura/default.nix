{ config, pkgs, ... }: {
  imports = [ 
    ../common.nix
    ./hardware.nix
    ./network.nix
    ./storage.nix
  ];

  config = {

    laurelin = {
      infra = {
        canon = "10.255.1.2";
        sound.enable = true;
        standard-packages.enable = true;
      };

      services = {
        window-manager = {
          enable = true;
          manager = "kde";
        };
      };

    };
  };
}
