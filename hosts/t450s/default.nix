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
    ../common/features/printing.nix
  ];

  networking.hostName = "t450s";
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true; # firmware updates: `fwupdmgr refresh && fwupdmgr get-updates`
  services.earlyoom.enable = true; # kill the biggest memory hog before the system freezes

  # TLP (enabled by nixos-hardware): charge only below 75%, stop at 80% to spare the batteries.
  # Full charge once (before a trip): `sudo tlp fullcharge`.
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    START_CHARGE_THRESH_BAT1 = 75;
    STOP_CHARGE_THRESH_BAT1 = 80;
    USB_EXCLUDE_BTUSB = 1; # no USB autosuspend for the Bluetooth chip (BLE keyboard/mouse drops)
    DEVICES_TO_DISABLE_ON_STARTUP = "wwan"; # unused LTE modem (Sierra EM7345); `tlp wwan on` to use it
  };

  # Lid closed (no external monitor): suspend; systemd hibernates later only if the battery
  # would run low (no HibernateDelaySec = battery-based). With a monitor connected: ignored.
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

  # Awake on battery: hibernate at 5% instead of dying.
  services.upower = {
    enable = true;
    percentageAction = 5;
    criticalPowerAction = "Hibernate";
  };
  systemd.services.upower.wantedBy = [ "multi-user.target" ]; # otherwise only started on demand (D-Bus)

  # Set once at install, never change (pins data formats, not the NixOS version).
  system.stateVersion = "26.05";
}
