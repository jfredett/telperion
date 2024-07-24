{ config, lib, pkgs, ... }: {
  imports = [
    <common/network-storage.nix>
  ];


  services.emerald-city.nfs = {
    "nancy.canon" = [
      {
        name = "vm";
        path = "/mnt/vm";
        host_path = "volume1";
        user = "root";
        group = "root";
        options = "defaults,hard,fg";
      }
    ];
  };
}
