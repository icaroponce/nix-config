{ pkgs, ... }:
{
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console (and the LUKS prompt, via earlySetup) uses the X layout below.
  console = {
    useXkbConfig = true;
    font = "ter-v24n";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
  };

  # Dvorak with AltGr dead keys, Caps Lock <-> Ctrl. Applies to every keyboard except the Ferris.
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak-alt-intl";
    model = "pc104";
    options = "terminate:ctrl_alt_bksp,ctrl:swapcaps";
  };

  # The Ferris (ZMK) does dvorak in firmware: plain us, no Caps swap.
  # Read after 00-keyboard.conf, and the last matching InputClass wins.
  environment.etc."X11/xorg.conf.d/90-ferris.conf".text = ''
    Section "InputClass"
      Identifier "Ferris: dvorak is done in firmware"
      MatchIsKeyboard "on"
      MatchProduct "Ferris"
      Option "XkbLayout" "us"
      Option "XkbVariant" "altgr-intl"
      Option "XkbOptions" "terminate:ctrl_alt_bksp"
    EndSection
  '';
}
