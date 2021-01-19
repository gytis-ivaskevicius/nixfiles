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
      inherit (builtins) readDir;
      inherit (utils) pathsToImportedAttrs recImport;
      system = "x86_64-linux";
      utils = import ./utility-functions.nix { inherit lib; };

      pkgImport = pkgs: overlays: import pkgs {
        inherit system overlays ;
        config = { allowUnfree = true; };
      };

      custom-pkgs = import ./pkgs;
      unstable-pkgs = pkgImport self.inputs.master [ custom-pkgs ];

      overlays = [
        custom-pkgs
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty;
          unstable = unstable-pkgs;
        })
      ];

      pkgset = {
        os-pkgs = pkgImport self.inputs.nixos overlays;
        inputs = self.inputs;
        nix-options = readDir ./nix-options;
      };
    in
    with pkgset;
    {
      nixosConfigurations = import ./hosts (recursiveUpdate inputs {
        inherit lib pkgset system utils;
      });

      overlay = custom-pkgs;
      overlays = overlays;
      packages."${system}" = (custom-pkgs null pkgset.os-pkgs);

      nixosModules = (recImport pkgset.nix-options);
    };
}
