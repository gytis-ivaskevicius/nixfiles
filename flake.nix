{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/staging;
    #utils.url = "/home/gytis/Projects/flake-utils-plus";

    nixpkgs-wayland = {
      url = github:colemickens/nixpkgs-wayland;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstableSmall.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager/master;
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
    in
    utils.lib.systemFlake {

      inherit self inputs;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      channels.nixpkgs.input = nixpkgs;

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
        oraclejdk.accept_license = true;
      };

      nixosProfiles =
        let
          desktopModules = with self.nixosModules; [
            base-desktop
            cli
            cli-extras
            sway
            xorg
          ];
        in
        with self.nixosModules; {

          GytisOS.modules = [
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
          firefox = prev.g-firefox.override {
            pipewireSupport = true;
            waylandSupport = true;
            webrtcSupport = true;
          };
        })
      ];

      sharedModules = with self.nixosModules; [
        cachix
        clean-home
        runtimes
        nix-compose

        home-manager.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nix.nixPath = [ "repl=${toString ./.}/repl.nix" ];
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
      defaultPackageBuilder = (chanels: chanels.nixpkgs.g-neovim);

      devShellBuilder = channels: with channels.nixpkgs.pkgs; mkShell {
        buildInputs = [ transcript ];
      };

      overlay = import ./overlays;

      nixosModules = utils.lib.modulesFromList [
        ./modules/cachix.nix
        ./modules/clean-home.nix
        ./modules/nix-compose.nix
        ./modules/runtimes.nix

        ./configurations/base-desktop.nix
        ./configurations/cli-extras.nix
        ./configurations/cli.nix
        ./configurations/containers.nix
        ./configurations/dev.nix
        ./configurations/sway.nix
        ./configurations/xorg.nix
      ];

    };
}




