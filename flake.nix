{
  description = "Telperion with Silver Fruit";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    dns = {
      url = "github:nix-community/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";  # (optionally)
    };

    laurelin = {
      url = "git+file:/home/jfredett/code/minas-tarwon/laurelin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    narya = {
      url = "git+file:/home/jfredett/code/minas-tarwon/narya";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    glamdring = {
      url = "git+file:/home/jfredett/code/minas-tarwon/glamdring";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, dns, laurelin, narya, glamdring, home-manager, nur, ... }: rec {

    # FIXME: This sucks, too messy.
    genDNS = with nixpkgs.lib; let
      mkZoneString = zone: config: toString (dns.lib.evalZone zone config);
      # TODO: Extract this.
      ecConf = let
        root = import ./emerald.city/dns.nix { inherit dns; };
        configs = map (c: c.config.laurelin.infra.dns) (attrValues self.nixosConfigTree."emerald.city");
      in mkZoneString "emerald.city" (mkMerge (configs ++ [root]));
      canonConf = let
        root = import ./cadaster { inherit dns; };
        configs = map (c: c.config.laurelin.infra.dns) (attrValues self.nixosConfigTree.canon);
      #in mkZoneString "canon" (mkMerge (configs ++ root));
      in mkZoneString "canon" (mkMerge (configs ++ root));
    in {
      zones = {
        canon = canonConf;
        "emerald.city" = ecConf;
      };
    };

    # This needs to be flat, but I want to store it in a more structured way, time to add another
    # layer.
    nixosConfigurations = with builtins; let
      mkFlat = domain: acc: el: acc // { "${el}.${domain}" = self.nixosConfigTree."${domain}"."${el}"; };
      flatten = domain: branch: foldl' (mkFlat domain) {} (attrNames branch."${domain}");
      canon = flatten "canon" self.nixosConfigTree;
      emerald-city = flatten "emerald.city" self.nixosConfigTree;
    in canon // emerald-city;

    nixosConfigTree = let
      vmConfigFor = path: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { system.stateVersion = "24.11"; }

          narya.nixosModules.default
          laurelin.nixosModules.default

          # FIXME: I don't think these two things should be here, they should be behind
          # laurelin/narya at least, ideally behind glamdring.
          home-manager.nixosModules.home-manager
          { home-manager.backupFileExtension = "backup"; }
          nur.nixosModules.nur
          path
        ];

        specialArgs = { root = self; inherit glamdring laurelin narya dns; };
      };
      configFor = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { system.stateVersion = "24.11"; }

          narya.nixosModules.default
          laurelin.nixosModules.default
          # FIXME: I don't think these two things should be here, they should be behind
          # laurelin/narya at least, ideally behind glamdring.
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          ./cadaster/${name}
        ];

        specialArgs = { root = self; inherit glamdring laurelin narya dns; };
      };
    in {
      # TODO: It might be better to do:
      #
      # archimedes = {
      #   canon = configFor "archimedes";
      #   "emerald.city" = configFor "archimedes" { additional-options };
      # };
      #
      # as this would allow punning of the form `.#archimedes.canon` and
      # `.#archimedes."emerald.city"`.
      canon = {
        archimedes = configFor "archimedes";
        maiasaura = configFor "maiasaura";
        dragon-of-perdition = configFor "dragon-of-perdition";
        babylon-the-great = configFor "babylon-the-great";
        toto = configFor "toto";
      };
      "emerald.city" = {
        barge = vmConfigFor ./emerald.city/roles/barge.nix;
        pinky = vmConfigFor ./emerald.city/roles/pinky.nix;
        randy = vmConfigFor ./emerald.city/roles/randy.nix;
        daktylos = vmConfigFor ./emerald.city/roles/daktylos.nix;
      };
    };

    # TODO: I don't like this name, maybe this is like, vmConfigs? libvirtConfigs? Eventually it
    # should have a more rich structure anyway...
    domains = {
      "emerald.city" = {
        domains = {
          barge = ./emerald.city/domains/barge.xml;
          pinky = ./emerald.city/domains/pinky.xml;
          randy = ./emerald.city/domains/randy.xml;
          daktylos = ./emerald.city/domains/daktylos.xml;
        };
        networks = {
          ec-net = ./emerald.city/networks/ec-net.xml;
        };
      };
    };

    scrapeTargets = with builtins; let
      isEnabled = exporter: c: c.config.laurelin.services.prometheus.exporters.${exporter}.enable;
      scrapeClientsFor = exporter: (filter (isEnabled exporter) (attrValues self.nixosConfigurations));
      mkScrapeConfigsFor = exporter: map (mkScrapeConfigFor exporter) (scrapeClientsFor exporter);
      mkScrapeConfigFor = exporter: conf: let
        hostName = conf.config.networking.hostName;
        domain = conf.config.laurelin.services.prometheus.exporters.node.domain;
        port = conf.config.laurelin.services.prometheus.exporters.node.port;
      in {
        job_name = "${hostName}-${exporter}";
        static_configs = [
          {
            labels = {
              hostname = hostName;
            };
            targets = [
              "${hostName}.${domain}:${toString port}"
            ];
          }
        ];
      };
      exporters = [
#        "domain"
#        "idrac"
        "ipmi"
        "nginx"
        "node"
#        "script"
        "systemd"
#        "zfs"
      ];
    in concatMap mkScrapeConfigsFor exporters;
  };
}
