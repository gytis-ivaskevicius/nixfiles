{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = github:nix-community/NUR;
    sops = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };

    home-manager = { url = github:nix-community/home-manager/master; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim = { url = github:neovim/neovim?dir=contrib; inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

    #wayland = { url = "github:colemickens/nixpkgs-wayland"; };
    #aarch-images = { url = "github:Mic92/nixos-aarch64-images"; flake = false; };

  };

  outputs = inputs@{ self, nur, sops, home-manager, nixpkgs-mozilla, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      my-pkgs = import ./overlays;

      utils = import ./utility-functions.nix {
        inherit lib system pkgs inputs self;
        nixosModules = self.nixosModules;
      };

      nixpkgs-patched = utils.patchChannel nixpkgs [ ];

      pkgs = utils.pkgImport nixpkgs-patched self.overlays;
    in
    {
      nixosModules = [
        home-manager.nixosModules.home-manager
        sops.nixosModules.sops
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
          neovim-nightly = inputs.neovim.defaultPackage.${system};
          firefox = g-firefox.override {
            pipewireSupport = true;
            waylandSupport = true;
            webrtcSupport = true;
          };
        })
      ];

      packages."${system}" = (my-pkgs null pkgs);

      devShell.${system} = with pkgs; mkShell rec  {
        # imports all files ending in .asc/.gpg and sets $SOPS_PGP_FP.
        sopsPGPKeyDirs = [
          "./secrets"
        ];
        shellHook = ''
          echo NIX SHELL!!!
          zsh
          exit
        '';
        nativeBuildInputs = [
          (pkgs.callPackage sops { }).sops-pgp-hook
        ];
      };
    };
}
