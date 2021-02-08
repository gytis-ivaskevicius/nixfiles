{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/master";
    nur.url = github:nix-community/NUR;

    home-manager = { url = github:nix-community/home-manager/release-20.09; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim = { url = github:neovim/neovim?dir=contrib; inputs.nixpkgs.follows = "master"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

    #wayland = { url = "github:colemickens/nixpkgs-wayland"; };
    #aarch-images = { url = "github:Mic92/nixos-aarch64-images"; flake = false; };

  };

  outputs = inputs@{ self, nur, neovim, home-manager, nixpkgs-mozilla, nixpkgs, master, ... }:
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
      nixpkgs-patched = utils.patchChannel nixpkgs [
        (unstable-pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/112268.patch";
          sha256 = "sha256-qB4lt3xhKzOeY0JGkvZKu5k2HyliujYV6yYcEGfQd8A=";
        })
      ];

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
        ./configurations/NixyServer.host.nix
      ];

      overlay = my-pkgs;
      overlays = [
        (import nixpkgs-mozilla)
        my-pkgs
        nur.overlay
        (final: prev: with prev; {
          neovim-nightly = neovim.defaultPackage.${system};
          firefox = g-firefox;

          #podman-compose = podman-compose.overrideAttrs (old: {
          #  src = fetchFromGitHub {
          #    owner = "containers";
          #    repo = "podman-compose";
          #    rev = "6289d25a42cfdb5dfcac863b1b1b4ace32ce31b7";
          #    sha256 = "0cy842wlyasxlxnwxkwhwgj148s30kfxnhgxa6ar26fly432aa68";
          #  };
          #});


          podman = podman.overrideAttrs (old: {
            src = fetchFromGitHub {
              owner = "containers";
              repo = "podman";
              rev = "v2.2.1";
              sha256 = "0cy842wlyasxlxnwxkwhwgj148s30kfxnhgxa6ar26fly432aa68";
            };
          });
        })
      ];

      packages."${system}" = (my-pkgs null pkgs);
    };
}
