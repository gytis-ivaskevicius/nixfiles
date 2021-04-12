{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/staging;
    #utils.url = "/home/gytis/Projects/flake-utils-plus";

    nixpkgs-wayland = {
      url = github:colemickens/nixpkgs-wayland;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstableSmall.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };

    forgit-git = {
      url = github:wfxr/forgit;
      flake = false;
    };

    lightcord-git = {
      url = github:Lightcord/Lightcord;
      flake = false;
    };
  };

  outputs = inputs@{ self, utils, nur, home-manager, nixpkgs-mozilla, nixpkgs, ... }:
    let
      mkApp = utils.lib.mkApp;

      desktopModules = with self.nixosModules; [
        base-desktop
        cli
        cli-extras
        sway
        ({ pkgs, ... }: {
          home-manager.users.gytis = import ./home-manager/sway.nix;
          boot.kernelPackages = pkgs.linuxPackages_latest;
        })
      ];
    in
    utils.lib.systemFlake {
      inherit self inputs;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      channels.nixpkgs.input = nixpkgs;

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
      };

      nixosProfiles = with self.nixosModules; {

        GytisOS.modules = [
          aarch64Dev
          dev
          (import ./profiles/work.secret.nix)
          (import ./profiles/GytisOS.host.nix)
        ] ++ desktopModules;

        Morty.modules = [
          (import ./profiles/Morty.host.nix)
        ] ++ desktopModules;

        NixyServer.modules = [
          containers
          (import ./profiles/NixyServer.host.nix)
        ];
      };

      sharedOverlays = [
        (import nixpkgs-mozilla)
        self.overlay
        nur.overlay
        (final: prev: {
          inherit inputs;
          neovim-nightly = inputs.neovim.defaultPackage.${prev.system};
          firefox = prev.g-firefox;
        })
      ];

      sharedModules = with self.nixosModules; [
        cachix
        clean-home
        runtimes
        nix-compose
        personal

        home-manager.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      packagesBuilder = chanels: {
        inherit (chanels.nixpkgs)
          g-alacritty
          g-firefox
          g-lf
          g-neovim
          g-pistol
          g-polybar
          g-rofi
          g-termite
          lightcord
          shell-config
          zsh-forgit
          ;
      };


      appsBuilder = channels: with channels.nixpkgs; {
        g-neovim = mkApp {
          drv = g-neovim;
          exePath = "/bin/nvim";
        };
        g-termite = mkApp {
          drv = g-termite;
          exePath = "/bin/termite";
        };
      };

      defaultPackageBuilder = channels: channels.nixpkgs.g-neovim;

      devShellBuilder = channels: with channels.nixpkgs.pkgs; mkShell {
        buildInputs = [ git transcript ];
      };

      overlay = import ./overlays;

      nixosModules = utils.lib.modulesFromList [
        ./modules/cachix.nix
        ./modules/clean-home.nix
        ./modules/nix-compose.nix
        ./modules/runtimes.nix

        ./configurations/aarch64Dev.nix
        ./configurations/base-desktop.nix
        ./configurations/cli-extras.nix
        ./configurations/cli.nix
        ./configurations/containers.nix
        ./configurations/dev.nix
        ./configurations/personal.nix
        ./configurations/sway.nix
        ./configurations/xorg.nix
      ];

    };
}


