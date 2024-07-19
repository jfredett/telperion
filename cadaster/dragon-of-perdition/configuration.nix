inputs@{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ./storage.nix
    ./network.nix

    <common/common.nix>
    <common/netbootable.nix>
    <common/vm-host.nix>
  ];

  environment.noXlibs = false;

  system.emerald-city.netbootable.enable = true;

  environment.systemPackages = with pkgs; [
    libvirt
    cmake
  ];

  networking.firewall.allowedTCPPorts = [ 22 5900 ];

  emerald-city.services.vm-host = {
    enable = true;
    backup_path = "/mnt/vm/${config.networking.hostName}";
    bridge_name = "ec-dmz-bridge";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}

