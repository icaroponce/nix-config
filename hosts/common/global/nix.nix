{ ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true; # dedupe identical files in /nix/store
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Keep /nix from growing forever.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
