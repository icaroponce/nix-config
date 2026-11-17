{
  description = "icaro's NixOS + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # Prebuilt nix-index database, used by comma.
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      # One pkgs set shared by NixOS and home-manager.
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      # sudo nixos-rebuild switch --flake .#t450s
      nixosConfigurations.t450s = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t450s
          ./hosts/t450s
        ];
      };

      # home-manager switch --flake .#icaro@t450s
      # Standalone, so home/ also works on non-NixOS systems (e.g. macOS).
      homeConfigurations."icaro@t450s" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor "x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/icaro/t450s.nix ];
      };

      formatter.x86_64-linux = (pkgsFor "x86_64-linux").nixfmt-rfc-style;
    };
}
