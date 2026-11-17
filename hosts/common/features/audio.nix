# Audio + Bluetooth, NixOS defaults.
{ pkgs, ... }:
{
  # PipeWire with the PulseAudio protocol, so pactl/pavucontrol work.
  security.rtkit.enable = true; # realtime priority for PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true; # BlueZ; PipeWire handles headsets by itself
  services.blueman.enable = true; # tray applet (started by xmonad) + blueman-manager

  environment.systemPackages = with pkgs; [
    pulseaudio # only for the `pactl` CLI; the server is PipeWire
    pavucontrol # volume mixer
  ];
}
