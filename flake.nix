{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/release-20.09";

    home-manager = { url = github:nix-community/home-manager/release-20.09; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly-overlay = { url = github:nix-community/neovim-nightly-overlay; inputs.nixpkgs.follows = "master"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

  };

  outputs = inputs@{ self, neovim-nightly-overlay, home-manager, nixpkgs-mozilla, nixpkgs, master, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      my-pkgs = import ./pkgs;

      utils = import ./utility-functions.nix {
        inherit lib system pkgs inputs self;
        nixosModules = self.nixosModules;
      };

      unstable-pkgs = utils.pkgImport master [ my-pkgs ];
      pkgs = utils.pkgImport nixpkgs self.overlays;
    in
    {
      nixosModules = [
        home-manager.nixosModules.home-manager
        (import ./nix-options)
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      nixosConfigurations = utils.buildNixosConfigurations [
        ./hosts/GytisOS.nix
      ];

      overlay = my-pkgs;
      overlays = [
        (import nixpkgs-mozilla)
        neovim-nightly-overlay.overlay
        my-pkgs
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty jetbrains jdk15 brave gitkraken gradle insomnia maven linuxPackages_latest;
          unstable = unstable-pkgs;
        })
      ];

      packages."${system}" = (my-pkgs null pkgs);
    };
}
