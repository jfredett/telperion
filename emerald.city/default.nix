{ ... }: let 
  hostConfig = {
    domains = ./domains;
    networks = ./networks;
  };
in rec {
  roles = {
    pinky = {
      type = "domain";
      definition = hostConfig.domains.pinky;
      config = import ./core-services/pinky.nix;
      network = {
        ip = "172.16.0.69";
        net = "ec-net";
      };
    };
  };
  networks = {
    ec-net = {
      type = "network";
      definition = hostConfig.networks.ec-net;
    };
  };
}
