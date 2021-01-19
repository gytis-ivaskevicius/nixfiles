{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixos.url = "nixpkgs/release-20.09";
    home.url = "github:nix-community/home-manager/release-20.09";
  };

  outputs = inputs@{ self, ... }:
    let
      inherit (inputs.nixos) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      my-pkgs = import ./pkgs;

      utils = import ./utility-functions.nix {
        inherit lib system pkgs inputs self;
        nixosModules = self.nixosModules;
      };

      unstable-pkgs = utils.pkgImport inputs.master [ my-pkgs ];
      pkgs = utils.pkgImport inputs.nixos self.overlays;
    in
    {
      nixosModules = [
        inputs.home.nixosModules.home-manager
        (import ./nix-options)
      ];

      nixosConfigurations = utils.buildNixosConfigurations [
        ./hosts/GytisOS.nix
      ];

      overlay = my-pkgs;
      overlays = [
        my-pkgs
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty;
          unstable = unstable-pkgs;
        })
      ];

      packages."${system}" = (my-pkgs null pkgs);
    };
}
