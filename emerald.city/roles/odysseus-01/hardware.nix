{ config, lib, pkgs, root, laurelin, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."swap" = {
    # TODO: Make this by-label? Not sure if it's there.
    device = "/dev/sda2";
    fsType = "swap";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
