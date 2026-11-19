{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./nix.nix
    ./network.nix
    ./locale.nix
  ];

  programs.zsh.enable = true;

  # sudo without a password; LUKS still protects the disk at rest.
  security.sudo.wheelNeedsPassword = false;

  # nh: nicer front end for rebuilds (shows a diff of changed packages, cleans old generations).
  #   nh os switch     = sudo nixos-rebuild switch --flake ~/nix-config#t450s
  #   nh home switch   = home-manager switch --flake ~/nix-config#icaro@t450s
  #   nh os switch -u  = also update flake.lock first
  programs.nh = {
    enable = true;
    flake = "/home/icaro/nix-config";
  };

  # Mount USB sticks without sudo: `udisksctl mount -b /dev/sdX1` -> /run/media/$USER/<label>
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gh # GitHub CLI (also git's HTTPS credentials)
    stow # links ~/dotfiles into ~
    curl
    wget
    p7zip # 7z archives
    htop
    pciutils # lspci
    usbutils # lsusb
    claude-code
    nodejs # runs the claude-hud status line
  ];

  # Runs prebuilt Linux binaries (npm/pip native binaries, rustup...) that expect /lib64/ld-linux.
  programs.nix-ld.enable = true;

  environment.variables.EDITOR = "nvim";
}
