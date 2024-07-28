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
    cfg = config.telperion;
  in {
    # TODO: Move this to laurelin
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
  }
}
