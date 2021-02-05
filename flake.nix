{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/release-20.09";

    home-manager = { url = github:nix-community/home-manager/release-20.09; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim = { url = github:neovim/neovim?dir=contrib; inputs.nixpkgs.follows = "master"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

    #wayland = { url = "github:colemickens/nixpkgs-wayland"; };
    #aarch-images = { url = "github:Mic92/nixos-aarch64-images"; flake = false; };

  };

  outputs = inputs@{ self, neovim, home-manager, nixpkgs-mozilla, nixpkgs, master, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      my-pkgs = import ./overlays;

      utils = import ./utility-functions.nix {
        inherit lib system pkgs inputs self;
        nixosModules = self.nixosModules;
      };

      unstable-pkgs = utils.pkgImport master [ my-pkgs ];


      tmp-pkgs = (import nixpkgs { inherit system; }).pkgs;
      nixpkgs-patched = tmp-pkgs.applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = [
          (tmp-pkgs.fetchpatch {
            url = "https://github.com/NixOS/nixpkgs/pull/93832/commits/20fa0c5949604671e200062dff009516e4d8ae84.patch";
            sha256 = "sha256-3gmtPyPgeVmF4CGdHm+ht088A++saGeeu/TBtkzypro=";
          })
        ];
      };
      #  pkgs = utils.pkgImport nixpkgs self.overlays;
      pkgs = utils.pkgImport nixpkgs-patched self.overlays;


    in
    {
      nixosModules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      nixosConfigurations = utils.buildNixosConfigurations [
        ./configurations/GytisOS.host.nix
      ];

      overlay = my-pkgs;
      overlays = [
        (import nixpkgs-mozilla)
        my-pkgs
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty jetbrains jdk15 brave gitkraken gradle insomnia maven linuxPackages_latest;
          unstable = unstable-pkgs;
          neovim-nightly = neovim.defaultPackage.${system};
        })
      ];

      packages."${system}" = (my-pkgs null pkgs);
    };
}
