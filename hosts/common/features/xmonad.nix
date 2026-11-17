# xmonad + xmobar from plain .hs files in dotfiles; both recompile themselves when changed.
# xmonadGhc uses the same package list as the xmonad module, so it is the same store path:
# one ghc for xmonad, xmobar (`ghc` on PATH) and ghci.
# Started with `startx` (~/.xinitrc from dotfiles).
{ pkgs, ... }:
let
  libs = hp: [
    hp.xmonad-contrib
    hp.xmobar
  ];
  xmonadGhc = pkgs.haskellPackages.ghcWithPackages (hp: [ hp.xmonad ] ++ libs hp);
in
{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;

    # Key repeat: delay (ms) and interval (ms).
    autoRepeatDelay = 300;
    autoRepeatInterval = 25;

    windowManager.xmonad = {
      enable = true;
      extraPackages = libs;
    };
  };

  services.libinput.enable = true; # touchpad

  # PAM entry for i3lock (used by i3lock-fancy-rapid); without it no password is accepted.
  programs.i3lock.enable = true;

  environment.systemPackages = with pkgs; [
    xmonadGhc # ghc + ghci with the xmonad libraries
    xmobar
    kitty # terminal
    brave # browser
    # Spawned by xmonad.hs / .xinitrc
    rofi # launcher, window switcher
    haskellPackages.greenclip # clipboard history (Super+c)
    dunst # notifications
    picom # compositor (transparency, shadows)
    networkmanagerapplet # nm-applet: wifi tray icon
    unclutter-xfixes # hides the idle mouse cursor
    autorandr # monitor profiles
    feh # wallpaper
    xrdb # loads .Xresources
    scrot # screenshots (Super+Print)
    flameshot # screenshots (Print)
    playerctl # media keys
    i3lock-fancy-rapid # lock screen
    xss-lock # locks on suspend and idle (started by xmonad)
    brightnessctl # brightness keys
    stalonetray # system tray
    xclip # clipboard from the CLI
  ];

  # Font for apps asking for "monospace"; sans/serif stay DejaVu.
  fonts.fontconfig.defaultFonts.monospace = [ "Liberation Mono" ];

  fonts.packages = with pkgs; [
    dejavu_fonts # xmobar main font
    nerd-fonts.symbols-only # xmobar icons
    symbola # xmobar emoji
    noto-fonts-color-emoji # emoji in apps
    nerd-fonts.liberation # kitty (LiterationMono Nerd Font)
  ];
}
