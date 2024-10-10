{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.follows = "nixpkgs";

    #utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    utils.url = "/home/gytis/Projects/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "utils";

    #nix2vim.url = "/home/gytis/Projects/nix2vim";
    nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
    nix2vim.inputs.nixpkgs.follows = "";
    nix2vim.inputs.flake-utils.follows = "utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    forgit-git = {
      url = "github:wfxr/forgit";
      flake = false;
    };

  };

  outputs = inputs@{ self, nix2vim, utils, home-manager, ... }:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      mkApp = utils.lib.mkApp;
      suites = import ./suites.nix { inherit utils; };
    in
    with suites.nixosModules;
    utils.lib.mkFlake {
      inherit self inputs;
      inherit (suites) nixosModules;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;
      channelsConfig.allowBroken = false;

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          #inherit (channels.unstable) pure-prompt neovim-unwrapped linuxPackages_latest gcc11Stdenv layan-gtk-theme;
        })
      ];

      hosts.GytisOS.modules = suites.desktopModules ++ [
        #aarch64Dev
        dev
        {
          security.apparmor.enable = true;
        }

        ./hosts/GytisOS.host.nix
      ];

      hosts.Monday.modules = suites.desktopModules ++ [
        aarch64Dev
        dev
        ./hosts/Monday.host.nix
        #./config/k3s.nix
      ];


      hosts."gytis-ivaskevicius".modules = suites.desktopModules ++ [
        dev
        ./hosts/gytis-ivaskevicius.host.nix
      ];

      hosts.Morty.modules = suites.desktopModules ++ [
        ./hosts/Morty.host.nix
      ];

      hosts.NixyServer.modules = [
        containers
        ./hosts/NixyServer.host.nix
      ];

      sharedOverlays = [
        self.overlay
        nix2vim.overlay
        (final: prev: {
          #nix2vimDemo = prev.g-neovim;
          firefox = prev.g-firefox;
        })
      ];

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
      ] ++ suites.sharedModules;


      #############################
      ### Flake package outputs ###
      #############################

      outputsBuilder = channels: with channels.nixpkgs;{
        defaultPackage = g-neovim;

        packages = {
          repl = pkgs.callPackage utils.blueprints.fup-repl { };
          inherit
            nix2vimDemo
            g-alacritty
            g-firefox
            g-lf
            g-pistol
            g-polybar
            g-rofi
            g-termite
            shell-config
            zsh-forgit
            ;
        };

        devShell = mkShell {
          buildInputs = [ git transcrypt ];
        };
      };

      overlay = import ./overlays;

    };
}

