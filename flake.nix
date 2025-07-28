{
  description = "A highly awesome system configuration.";

  nixConfig = {
    extra-substituters = [ "https://cosmic.cachix.org" ];
    extra-trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };
  inputs = {
    #nixpkgs.url = "/home/gytis/nixpkgs/";
    #unstable.url = "/home/gytis/nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";


    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    #utils.url = "/home/gytis/Projects/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    #nix2vim.url = "/home/gytis/Projects/nix2vim";
    nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
    nix2vim.inputs.nixpkgs.follows = "";
    nix2vim.inputs.flake-utils.follows = "utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forgit-git = {
      url = "github:wfxr/forgit";
      flake = false;
    };

  };

  outputs =
    inputs@{ self
    , nix2vim
    , utils
    , home-manager
    , nixos-hardware
    , ...
    }:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      inherit (utils.lib) mkApp;
      suites = import ./suites.nix { inherit utils; };
    in
    with suites.nixosModules;
    utils.lib.mkFlake {
      inherit self inputs;
      inherit (suites) nixosModules;

      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
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
        inputs.nixos-cosmic.nixosModules.default
        ./hosts/Monday.host.nix
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-cpu-amd-zenpower
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

        packages = {
          repl = pkgs.callPackage utils.blueprints.fup-repl { };
          inherit
            nix2vimDemo
            g-alacritty
            g-firefox
            g-lf
            g-rofi
            shell-config
            ;
        };

        devShell = mkShell {
          buildInputs = [ git transcrypt ];
        };
      };

      overlay = import ./overlays;

    };
}

