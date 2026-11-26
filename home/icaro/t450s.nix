{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./autorandr.nix
    ./fastfetch.nix
    ./anki.nix
    ./mimeapps.nix
  ];

  home.homeDirectory = "/home/icaro";

  # Linux desktop apps; portable CLI tools go in common.nix.
  home.packages = with pkgs; [
    zathura # PDF viewer
    nsxiv # image viewer
    mpv # video/audio player
    galculator # calculator
    thunar # graphical file manager
    pwvucontrol # PipeWire volume mixer
  ];

  # Haskell LSP for nvim (haskell-tools) outside project flakes; pulls in a full GHC, so not shared.
  # Built for the default GHC = xmonadGhc's (xmonad.hs, xmobar.hs).
  programs.neovim.extraPackages = [ pkgs.haskell-language-server ];

  # Mouse cursor: ~/.icons/default (X and GTK apps) + Xcursor.* in ~/.Xresources.
  home.pointerCursor = {
    enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  # GTK apps (thunar, galculator, pwvucontrol): dark theme + icons.
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };
  # GTK4/libadwaita apps follow this instead of the theme.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # CUPS user defaults: A4 (the printer itself reports Letter).
  home.file.".cups/lpoptions".text = "Default LaserJet_M12w PageSize=A4\n";

  # Writes ~/.Xresources (merged by .xinitrc).
  xresources.properties."Xft.dpi" = 112;

  # Set once at install, never change.
  home.stateVersion = "26.05";
}
