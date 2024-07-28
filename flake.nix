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

    dns = with dns.lib.combinators; with nixpkgs.lib; let
      configs = map (c: c.config.laurelin.infra.dns) (attrValues self.nixosConfigurations);
      root = import ./cadaster { inherit dns; };
      allconfs = mkMerge (configs ++ root);
    in {
      zones = {
        canon = toString (dns.lib.evalZone "canon" allconfs);
      };
      hosts = {
        canon = ''
          127.0.0.1 localhost
          ::1 localhost
          # TODO: Implement the rest of this
        '';
      };
    };

    # This needs to be flat, but I want to store it in a more structured way, time to add another
    # layer.
    nixosConfigurations = with builtins; let
      mkFlat = domain: acc: el: acc // { "${domain}.${el}" = self.nixosConfigTree."${domain}"."${el}"; };
      flatten = domain: branch: foldl' (mkFlat domain) {} (attrNames branch."${domain}");
      cadaster = flatten "cadaster" self.nixosConfigTree;
      emerald-city = flatten "emerald.city" self.nixosConfigTree;
    in cadaster // emerald-city;

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
          nur.nixosModules.nur
          path
        ];

        specialArgs = { root = self; inherit glamdring laurelin dns; };
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

        specialArgs = { root = self; inherit glamdring laurelin dns; };
      };
    in {
      # TODO: wrap these in a `canon` parent and adjust appropriately. Other configs should be
      # provided via other parents.
        # TODO: This should be named 'canon' not 'cadaster', and I should reverse the order (hostname
        # first) to match the DNS zone.
      cadaster = {
        archimedes = configFor "archimedes";
        maiasaura = configFor "maiasaura";
        dragon-of-perdition = configFor "dragon-of-perdition";
        babylon-the-great = configFor "babylon-the-great";
        toto = configFor "toto";
      };
      "emerald.city" = {
        pinky = vmConfigFor ./emerald.city/roles/pinky.nix;
        barge = vmConfigFor ./emerald.city/roles/barge.nix;
      };
    };

    # TODO: I don't like this name, maybe this is like, vmConfigs? libvirtConfigs? Eventually it
    # should have a more rich structure anyway...
    domains = {
      "emerald.city" = {
        domains = {
          barge = ./emerald.city/domains/barge.xml;
          pinky = ./emerald.city/domains/pinky.xml;
        };
        networks = {
          ec-net = ./emerald.city/networks/ec-net.xml;
        };
      };
    };
  };
}
