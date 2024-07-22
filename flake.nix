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

    glamdring = {
      url = "git+file:/home/jfredett/code/minas-tarwon/glamdring";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, dns, laurelin, narya, glamdring, ... }: {

    dns =
    with dns.lib.combinators;
    with nixpkgs.lib;
    let
      configs = map (c: c.config.laurelin.infra.dns) (attrValues self.nixosConfigurations);
      root = import ./cadaster { inherit dns; };
      allconfs = mkMerge (configs ++ root);
    in {
      zones = {
        canon = toString (dns.lib.evalZone "canon" allconfs);
      };
    };

    nixosConfigurations = let
      configFor = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          narya.nixosModules.default
          laurelin.nixosModules.default
          ./cadaster/${name}
        ];

        specialArgs = { inherit dns; };
      };
    in {
      # TODO: wrap these in a `canon` parent and adjust appropriately. Other configs should be
      # provided via other parents.
      archimedes = configFor "archimedes";
      maiasaura = configFor "maiasaura";
      dragon-of-perdition = configFor "dragon-of-perdition";
      babylon-the-great = configFor "babylon-the-great";
      toto = configFor "toto";
    };
  };
}
