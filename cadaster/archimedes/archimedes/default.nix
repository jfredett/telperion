{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ./network.nix
    ./storage.nix
    ./config.nix
  ];


  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ## TODO: Extract this to a nixos module in ./nixos/
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
