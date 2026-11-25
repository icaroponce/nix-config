# macOS (Apple Silicon), home-manager standalone. GUI apps stay in Homebrew.
{ ... }:
{
  imports = [ ./common.nix ];

  home.homeDirectory = "/Users/icaro";

  # Set once at install, never change.
  home.stateVersion = "26.11";
}
