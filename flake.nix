{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
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

  };

  outputs = inputs@{ self, utils, nur, home-manager, nixpkgs-mozilla, nixpkgs, ... }:
    let
      mkApp = utils.lib.mkApp;
    in
    utils.lib.systemFlake {

      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
        oraclejdk.accept_license = true;
        permittedInsecurePackages = [ "openssl-1.0.2u" ];
      };

      nixosProfiles = {
        GytisOS.modules = [ (import ./configurations/GytisOS.host.nix) ];

        Morty.modules = [ (import ./configurations/Morty.host.nix) ];

        NixyServer.modules = [ (import ./configurations/NixyServer.host.nix) ];
      };

      overlay = import ./overlays;

      sharedOverlays = [
        (import nixpkgs-mozilla)
        self.overlay
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

      sharedModules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          nix = utils.lib.nixDefaultsFromInputs inputs;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        {
          nix.nixPath = [ "repl=${toString ./.}/repl.nix" ];
        }
      ];

      packagesFunc = (pkgs: {
        inherit (pkgs)
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
      });
      defaultPackageFunc = (pkgs: pkgs.g-neovim);

    };
}




