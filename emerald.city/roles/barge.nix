{ config, lib, pkgs, ... }: {
  laurelin = {
    infra = {
      canon = "10.255.1.70";
      mac = "02:ec:17:00:00:69";
    };
  };

  narya = {
    jfredett = true;
  };
}

