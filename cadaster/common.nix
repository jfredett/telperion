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
    unconditional = {
      time.timeZone = "America/New_York";

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      nix = {
        package = pkgs.nixFlakes;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      };

      nixpkgs.config.allowUnfree = true;

      security.rtkit.enable = true;

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
    };

    audio = {
      hardware.pulseaudio.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    standard-packages = {
      environment.systemPackages = with pkgs; [
        neovim
        python3
        wget
        lsof
        nmap
        inetutils
        git
        curl
        jq
        yq
        ripgrep
        dig
      ];
    };

    cfg = config.telperion;
  in unconditional
  // (mkIf cfg.sound audio)
  // (mkIf cfg.standardPackages standard-packages);
}
