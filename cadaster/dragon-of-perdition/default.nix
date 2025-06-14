{ config, root, laurelin, ... }: {
  imports = [
    # TODO: Should this be a module instead of an import?
    ../hardware/r730.nix
    ./network.nix
    ./storage.nix

  ];

  config = let
    gpu_id = "xxxx:xxxx";
  in {
    # boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "rd.driver.pre=vfio-pci" ];
    # boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
    # boot.kernelModules = [
    #   "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"
    #   "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
    # ];

    # boot.extraModprobeConfig = ''
    #   options vfio-pci ids=${p40id}
    # '';

    # boot.postBootCommands = /* bash */ ''
    #   DEVS="${p40id}"

    #   for DEV in $DEVS; do
    #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    #   done

    #   modprobe -i vfio-pci
    # '';
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    laurelin = {
      infra = {
        canon = "10.255.1.3";
        standard-packages.enable = false;
      };

      services = {
        promtail = {
          enable = true;
          lokiUrl = "http://loki.emerald.city";
        };
        prometheus.exporters = {
          node = {
            enable = true;
            domain = "canon";
          };
          systemd = {
            enable = true;
            domain = "canon";
          };
        };

        /*
        vm-host = {
          enable = false;
          backup_path = "/mnt/vm/${config.networking.hostName}";
          bridge_name = "ec-dmz-bridge";
          loadout = with laurelin.lib.vm; with root.domains."emerald.city"; {
            domains = [
            ];
            networks = [
            ];
          };
        };
        */
      };

      /*
      nfs = {
        "nancy.canon" = [
          {
            name = "vm";
            path = "/mnt/vm";
            host_path = "volume1";
            user = "root";
            group = "root";
            options = "defaults,hard,fg";
          }
        ];
      };
      */
    };

    narya.users = {
      home-manager.enable = true;

      jfredett = {
        enable = true;
        mode = "dragon";
      };
      builder.enable = true;
    };
  };
}
