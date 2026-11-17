{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./autorandr.nix
    ./fastfetch.nix
  ];

  home.homeDirectory = "/home/icaro";

  # Linux desktop apps; portable CLI tools go in common.nix.
  home.packages = with pkgs; [
    zathura # PDF viewer
    mpv # video/audio player
    anki # flashcards
    galculator # calculator
    thunar # graphical file manager
    pwvucontrol # PipeWire volume mixer
  ];

  # Set once at install, never change.
  home.stateVersion = "26.05";
}
