{ config, lib, pkgs, laurelin, ... }: {
  imports = [
    laurelin.nixosModules.netbootable
  ];

  config = {
    networking.hostName = "pinky";

    laurelin = {
      infra = {
        canon = "10.255.1.69";
      };

      netboot = {
        netbootable = true;
        mac = "02:ec:17:00:00:69";
      };
    };

    narya.users = {
      jfredett = true;
    };
  };
}
