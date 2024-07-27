# TODO: This might should be in laurelin, but it feels like it should be here because it's hardware
# specification. I'm going to leave it here for now, build up the whole codebase, and then see if it
# makes sense to move.
{ config, lib, pkgs, ... }: with lib; {
  options.telperion = {
    sound = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sound support";
    };

    standardPackages = mkOption {
      type = types.bool;
      default = true;
      description = "Install standard packages";
    };
  };

  config = let
    audio = {
    };

    standard-packages = {
    };

    cfg = config.telperion;
  in {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings.main = {
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  } // (mkIf cfg.sound audio)
  // (mkIf cfg.standardPackages standard-packages);
}
