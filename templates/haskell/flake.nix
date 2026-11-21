{
  description = "Haskell project: dev shell (GHC with the cabal dependencies from nixpkgs, cabal, HLS)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (
        pkgs:
        let
          hp = pkgs.haskellPackages;
        in
        {
          # GHC comes with every build-depends of the .cabal file, so cabal builds offline.
          # New dependency: add it to the .cabal file; direnv reloads the shell.
          default = hp.shellFor {
            packages = _: [ (hp.callCabal2nix "project" ./. { }) ];
            nativeBuildInputs = [
              hp.cabal-install
              pkgs.haskell-language-server # built for the same GHC
              hp.fourmolu
              hp.hlint
              pkgs.ghcid
              pkgs.just
            ];
          };
        }
      );
    };
}
