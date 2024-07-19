{
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      sdb = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      sdc = {
        type = "disk";
        device = "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      sdd = {
        type = "disk";
        device = "/dev/sdd";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      /* TODO: This can't be turned into an L2ARC by disko, so that'll have to be in the subsequent
      script in `format-disks.sh`.
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
      */
    };
    zpool = {
      storage = {
        type = "zpool";
        mode = "raidz";
        rootFsOptions = {
          canmount = "off";
          atime = "off";
          dedup = "on";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          nfs = {
            type = "zfs_fs";
            mountpoint = "/storage/nfs";
            options.compression = "lz4";
            options."com.sun:auto-snapshot" = "true";
          };

          torrent = {
            type = "zfs_fs";
            mountpoint = "/storage/torrent";
            options.compression = "lz4";
            options.recordsize = "16k";
          };

          media = {
            type = "zfs_fs";
            mountpoint = "/storage/media";
            options.compression = "zle";
          };
        };
      };
    };
  };
}
