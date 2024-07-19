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

    dns =
    with dns.lib.combinators;
    with nixpkgs.lib;
    let
      configs = map (c: c.laurelin.infra.dns) (attrNames self.nixosConfigurations);
      root = import ./cadaster/canon-zone.nix { inherit dns; };
      canonzone = mkMerge (configs // [root]);
    in {
      zones = builtins.trace canonzone {
        canon = toString (dns.lib.evalZone "canon" (mkMerge [
          self.nixosConfigurations.archimedes.config.laurelin.infra.dns
          self.nixosConfigurations.maiasaura.config.laurelin.infra.dns
          self.nixosConfigurations.dragon-of-perdition.config.laurelin.infra.dns
          root
          ]));
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
        dragon-of-perdition = configFor "dragon-of-perdition";
      };
    };
  }
