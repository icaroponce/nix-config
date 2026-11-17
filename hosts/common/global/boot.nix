{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # keep /boot (1G) from filling up
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true; # Intel wifi firmware
}
