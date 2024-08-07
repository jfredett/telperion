# TODO: Move to laurelin
# Alternate module name: "We have disko at home"
{ config, lib, pkgs, modulesPath, narya, ... }: with lib; let
  # TODO: Move this over to narya
  devices = narya.infra.disks.btg; 
  zfs = with devices.lib; {
    pools = {
      tank = {
        vdevs = [
          {
            disks = diskpathsFor [ "ssd-0" "ssd-1" "ssd-2" "ssd-3" ];
            raid = "raidz";
          }
          {
            disks = diskpathsFor [ "ssd-4" "ssd-5" "ssd-6" "ssd-7" ];
            raid = "raidz";
          }
        ];
        cache = disk "nvme-0";
        options = [
          "-m none"
          "-o ashift=12"
        ];
        settings = [
          "compression=on"
          "atime=off"
          "xattr=sa"
        ];
      };
    };
    datasets = {
      tank = [
        {
          name = "torrent";
          settings = [
            "compression=zstd"
            "canmount=on"
            "mountpoint=/mnt/tank/torrent"
            "atime=off"
            "xattr=sa"
            "recordsize=16K"
          ];
        }
        {
          name = "nfs";
          settings = [
            "compression=zstd"
            "sharenfs=on"
            "canmount=on"
            "mountpoint=/mnt/tank/nfs"
            "atime=off"
            "xattr=sa"
            "recordsize=128K"
          ];
        }
        {
          name = "vm";
          settings = [
            "compression=zstd"
            "atime=off"
            "canmount=on"
            "mountpoint=/mnt/tank/vm"
          ];
        }
        {
          name = "media";
          settings = [
            "compression=zle"
            "atime=off"
            "xattr=sa"
            "recordsize=1M"
            "canmount=on"
            "mountpoint=/mnt/tank/media"
          ];
        }
      ];
    };
  };

  poolName = "tank";
  wipeFSCmds = "wipefs -a ${concatStringsSep " " devices.lib.allDevices}";
  vdevs = zfs.pools.tank.vdevs;
  poolDef = with builtins; let
    first-vDev = (head vdevs);
    other-vDevs = concatStringsSep "\n" (
      map (def: "zpool add ${poolName} ${def.raid} ${concatStringsSep " " def.disks}") (tail vdevs)
      );
      options = concatStringsSep " " zfs.pools.tank.options;
  in ''
  zpool create ${poolName} ${options} ${first-vDev.raid} ${concatStringsSep " " first-vDev.disks}
  ${other-vDevs}
  '';
  cacheDef = "zpool add ${poolName} cache ${zfs.pools.tank.cache}";
  poolSettings = concatStringsSep "\n" (
    map (setting: "zfs set ${setting} ${poolName}") zfs.pools.tank.settings
  );
  datasets = zfs.datasets.tank;
  datasetDefs = (
    concatStringsSep "\n\n" (
      map (ds:
        "echo 'Creating dataset ${poolName}/${ds.name}'\n" +
        "zfs create ${poolName}/${ds.name} \n" +
        concatStringsSep "\n" (
          map (setting: "zfs set ${setting} ${poolName}/${ds.name}") ds.settings
        )
        ) datasets
      )
    );
    prepareZFS = (pkgs.writeShellApplication {
      name = "prepare-zfs";
      runtimeInputs = with pkgs; [ coreutils ];
      text = ''
        if zpool list ${poolName} ; then
          echo "Pool ${poolName} already exists, destroy it and free all listed resources and try again"
          exit 1
        fi

        set -x

        # Wipe the disks
        ${wipeFSCmds}

        # Build the pool
        ${poolDef}
        ${cacheDef}

        # Configure the Pool
        ${poolSettings}

        # Create the datasets
        ${datasetDefs}

        zpool status
        zpool list tank
      '';
    });
in {
  options.telperion.infra.zfs = {
    mode = mkOption {
      type = types.enum [ "format" "mount" ];
      default = "mount";
      description = ''
        The mode to use for the zfs configuration, in 'format' mode, a script `prepare-zfs` is provided which will
        format the drives and create the zfs pool, in 'mount' mode, the datasets from the specification will be mounted.
      '';
    };
  };

  config = let
    cfg = config.telperion.infra.zfs;
    mounting = cfg.mode == "mount";
    formatting = cfg.mode == "format";
  in {
    # A oneshot, manually-run service to run the prepare-zfs script
    environment.systemPackages = mkIf formatting [ prepareZFS ];

    boot.zfs.extraPools = mkIf mounting [ poolName ];
  };
}
