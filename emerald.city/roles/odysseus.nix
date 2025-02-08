# This machine expects a disk mounted at /mnt/local, and mounts NFS on /mnt/$name for each nfs
# mount. The former disk should be fast, local storage.

{ config, lib, pkgs, root, laurelin, narya, ... }: {
  imports = [
    ./odysseus
  ];
}
