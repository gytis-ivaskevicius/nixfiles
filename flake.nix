{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/release-20.09";
    home.url = "github:nix-community/home-manager/release-20.09";
  };

  outputs = inputs@{ self, ... }:
    let
      inherit (self.inputs.nixos) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      utils = import ./utility-functions.nix { inherit lib; };

      pkgImport = pkgs: overlays: import pkgs {
        inherit system overlays;
        config = { allowUnfree = true; };
      };

      custom-pkgs = import ./pkgs;
      unstable-pkgs = pkgImport self.inputs.master [ custom-pkgs ];
      pkgs = pkgImport self.inputs.nixos overlays;

      overlays = [
        custom-pkgs
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty;
          unstable = unstable-pkgs;
        })
      ];

      #        nix-options = readDir ./nix-options;
    in
    {
      nixosModules = [
        inputs.home.nixosModules.home-manager
        (import ./nix-options)
      ];

      nixosConfigurations = import ./hosts (recursiveUpdate inputs {
        inherit lib system utils pkgs inputs;
        nixosModules = self.nixosModules;
      });

      overlay = custom-pkgs;
      overlays = overlays;
      packages."${system}" = (custom-pkgs null pkgs);
    };
}
