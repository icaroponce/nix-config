{ ... }:
{
  # Connect with `nmtui` (TTY) or `nmcli device wifi connect <SSID> --ask`.
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
}
