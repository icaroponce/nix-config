# Disk layout (INSTALL.md):
#   p1  1G    EFI   vfat, label BOOT
#   p2  16G   LUKS  partlabel cryptswap  -> swap (also used for hibernation)
#   p3  rest  LUKS  partlabel cryptroot  -> btrfs, label nixos, subvolumes @root @home @nix
# Both LUKS volumes share one passphrase; NixOS asks once and reuses it.
{ ... }:
let
  btrfsOpts = [
    "compress=zstd"
    "noatime"
  ];
in
{
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-partlabel/cryptroot";
      allowDiscards = true;
    };
    cryptswap = {
      device = "/dev/disk/by-partlabel/cryptswap";
      allowDiscards = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@root" ] ++ btrfsOpts;
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@home" ] ++ btrfsOpts;
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@nix" ] ++ btrfsOpts;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ];
  boot.resumeDevice = "/dev/mapper/cryptswap"; # hibernation target

  services.fstrim.enable = true;
}
