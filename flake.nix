{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/master";
    nur.url = github:nix-community/NUR;
    sops = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-ld = { url = "github:Mic92/nix-ld"; inputs.nixpkgs.follows = "nixpkgs"; };

    ion = { url = github:redox-os/ion; flake = false; };
    podman = { url = github:containers/podman; flake = false; };

    home-manager = { url = github:nix-community/home-manager/master; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim = { url = github:neovim/neovim?dir=contrib; inputs.nixpkgs.follows = "master"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

    #wayland = { url = "github:colemickens/nixpkgs-wayland"; };
    #aarch-images = { url = "github:Mic92/nixos-aarch64-images"; flake = false; };

  };

  outputs = inputs@{ self, nur, sops, neovim, home-manager, nixpkgs-mozilla, nixpkgs, master, ... }:
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
          neovim-nightly = neovim.defaultPackage.${system};

          ion = ion.overrideAttrs (old: rec {
            srcs = inputs.ion;
            cargoDeps = old.cargoDeps.overrideAttrs (_: {
              src = srcs;
              outputHash = "sha256-BmcPlyJBWDWwWZzpP8PGbjxhrNpQxkk5nC0eG8JB7dA=";
            });
          });

          firefox = g-firefox.override {
            pipewireSupport = true;
            waylandSupport = true;
            webrtcSupport = true;
          };

          podman = podman.overrideAttrs (old: {
            src = inputs.podman;
            #src = fetchFromGitHub {
            #  owner = "containers";
            #  repo = "podman";
            #  rev = "5b2585f5e91ca148f068cefa647c23f8b1ade622";
            #  sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
            #};
          });
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
