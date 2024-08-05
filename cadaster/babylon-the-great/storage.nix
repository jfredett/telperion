# TODO: Move to laurelin
# Alternate module name: "We have disko at home"
{ config, lib, pkgs, modulesPath, ... }: with lib; let
  allDevices = [
    "/dev/sda"
    "/dev/sdb"
    "/dev/sdc"
    "/dev/sdd"
    "/dev/sde"
    "/dev/sdf"
    "/dev/sdg"
    "/dev/sdh"
    "/dev/nvme0n1"
  ];
  zfs = {
    pools = {
      tank = {
        vdevs = [
          {
            disks = "/dev/sda /dev/sdb /dev/sdc /dev/sdd";
            raid = "raidz";
          }
          {
            disks = "/dev/sde /dev/sdf /dev/sdg /dev/sdh";
            raid = "raidz";
          }
        ];
        cache = "/dev/nvme0n1";
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
          ];
        }
        {
          name = "media";
          settings = [
            "compression=zle"
            "atime=off"
            "xattr=sa"
            "recordsize=1M"
          ];
        }
      ];
    };
  };
  poolName = "tank";
  wipeFSCmds = foldl' (acc: d: "${acc} ${d}") "wipefs -a " allDevices;
  vdevs = zfs.pools.tank.vdevs;
  poolDef = with builtins; let
    first-vDev = (head vdevs);
    other-vDevs = concatStringsSep "\n" (
      map (def: "zpool add ${poolName} ${def.raid} ${def.disks}") (tail vdevs)
    );
    options = concatStringsSep " " zfs.pools.tank.options;
  in ''
    zpool create ${poolName} ${options} ${first-vDev.raid} ${first-vDev.disks}
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
      set -x
      # parse arguments
      for arg in "$@" ; do
        case "$arg" in
          --force)
            force=true
            ;;
          *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
        esac
      done
      # check to see if the pool already exists and is formatted
      if zpool list ${poolName} ; then
        # if it does, quit
        if ! $force ; then
          echo "Pool ${poolName} already exists, use --force to wipe and recreate"
          exit 1
        fi
      fi

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
  # A oneshot, manually-run service to run the prepare-zfs script
  environment.systemPackages = [ prepareZFS ];


  # filesystems that conditionally mount if the disks have been formatted already

}
