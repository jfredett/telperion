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
  };

  outputs = inputs @ { self, nixpkgs, dns, laurelin, ... }: {

    dns = with dns.lib.combinators; let
      cfg = {
        # This should be some function of the config that maps over all it's addresses and so on.
        archimedes = self.nixosConfigurations.archimedes.config;
        maiasaura = self.nixosConfigurations.maiasaura.config;
        root = import ./cadaster/canon-zone.nix { inherit dns; };
      };

    in {
      zones = {
        canon = toString (dns.lib.evalZone "canon" (
          nixpkgs.lib.mkMerge [
            cfg.archimedes.laurelin.infra.dns
            cfg.maiasaura.laurelin.infra.dns
            cfg.root
          ]
          ));
        };
      };

      nixosConfigurations = let
        configFor = name: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            laurelin.nixosModules.default
            ./cadaster/${name}
          ];

          specialArgs = { inherit dns; };
        };
      in {
        archimedes = configFor "archimedes";
        maiasaura = configFor "maiasaura";
      };
    };
  }
