{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    nixpkgs-2009.url = github:nixos/nixpkgs/nixos-20.09;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/;
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
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      mkApp = utils.lib.mkApp;
      suites = import ./suites.nix { inherit utils; };
    in
    utils.lib.systemFlake {
      inherit self inputs;
      inherit (suites) nixosModules;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [
          (final: prev: { jetbrains = channels.nixpkgs-2009.jetbrains; })
        ];
      };

      channels.nixpkgs-2009.input = inputs.nixpkgs-2009;


      hosts = with suites.nixosModules; {
        GytisOS.modules = suites.desktopModules ++ [
          aarch64Dev
          dev
          ./profiles/work.secret.nix
          ./profiles/GytisOS.host.nix
        ];

        Morty.modules = suites.desktopModules ++ [
          ./profiles/Morty.host.nix
        ];

        NixyServer.modules = [
          containers
          ./profiles/NixyServer.host.nix
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

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
      ] ++ suites.sharedModules;


      #############################
      ### Flake package outputs ###
      #############################

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
          shell-config
          zsh-forgit
          ;
      };

      packages.x86_64-linux = {
        inherit (pkgs) lightcord;
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
        buildInputs = [ git transcrypt ];
      };

      overlay = import ./overlays;


    };
}


