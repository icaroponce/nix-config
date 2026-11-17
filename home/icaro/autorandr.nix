# Monitor profiles. xmonad runs `autorandr --change` on start and on every monitor change.
{ ... }:
let
  # EDIDs from `autorandr --fingerprint`
  laptop = "00ffffffffffff0006af3d130000000026170104951f11780287e5a456509e260d505400000001010101010101010101010101010101143780b87038244010103e0035ad100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414e30312e33200a007a";
  monitor = "00ffffffffffff0010ac37424c4e574a0a200103803c2278eeee95a3544c99260f5054a54b00714f8180a9c0a940d1c0010101010101565e00a0a0a029503020350055502100001a000000ff00483730363948330a2020202020000000fc0044454c4c20553237323244450a000000fd00314c1e5a19000a20202020202001d6020324f14f90050403020716010611121513141f23097f078301000067030c001000383c023a801871382d40582c450055502100001e7e3900a080381f4030203a0055502100001a011d007251d01e206e28550055502100001ebf1600a08038134030203a0055502100001a0000000000000000000000000000000000000010"; # external monitor on HDMI
in
{
  programs.autorandr = {
    enable = true;

    profiles = {
      # Laptop alone.
      mobile = {
        fingerprint.eDP-1 = laptop;
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            rate = "60.05";
            position = "0x0";
          };
        };
      };

      # External monitor only, laptop screen off. Mode pinned: X otherwise picks an interlaced one.
      hdmi-only = {
        fingerprint = {
          eDP-1 = laptop;
          HDMI-1 = monitor;
        };
        config = {
          eDP-1.enable = false;
          HDMI-1 = {
            enable = true;
            primary = true;
            mode = "2048x1080";
            rate = "60.00";
            position = "0x0";
          };
        };
      };
    };
  };
}
