{ ... }:
{
  imports = [
    ./hardware-configuration.nix # nixos-generate-config --no-filesystems
    ./fs.nix
    ../common/global
    ../common/users/icaro.nix
    ../common/features/xmonad.nix
    ../common/features/audio.nix
    ../common/features/docker.nix
  ];

  networking.hostName = "t450s";
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true; # firmware updates: `fwupdmgr refresh && fwupdmgr get-updates`
  services.earlyoom.enable = true; # kill the biggest memory hog before the system freezes

  # Set once at install, never change (pins data formats, not the NixOS version).
  system.stateVersion = "26.05";
}
