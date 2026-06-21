{
  description = "A highly awesome system configuration.";

  inputs = {
    #nixpkgs.url = "/home/gytis/nixpkgs/";
    #unstable.url = "/home/gytis/nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs";


    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    #utils.url = "/home/gytis/Projects/flake-utils-plus";

    nix2vim.url = "/home/gytis/Projects/NIX/nix2vim";
    #nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
    nix2vim.inputs.nixpkgs.follows = "";
    nix2vim.inputs.flake-utils.follows = "utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self
    , nix2vim
    , utils
    , home-manager
    , nixos-hardware
    , ...
    }: let
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
          inherit (channels.unstable) claude-code code cursor bun opencode spec-kit vscode nixfmt;
          #inherit (channels.unstable) pure-prompt neovim-unwrapped linuxPackages_latest gcc11Stdenv layan-gtk-theme;
        })
      ];


      hosts.Monday.modules = suites.desktopModules ++ [
        aarch64Dev
        dev
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
        {
          home-manager.useGlobalPkgs = true;
        }
      ] ++ suites.sharedModules;


      #############################
      ### Flake package outputs ###
      #############################

      outputsBuilder = channels: with channels.nixpkgs;{

        packages = {
          repl = pkgs.callPackage utils.blueprints.fup-repl { };
          inherit
            nix2vimDemo
            g-firefox
            g-lf
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

