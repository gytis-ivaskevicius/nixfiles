{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    utils.url = github:numtide/flake-utils;

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
      pkgs = self.pkgs.nixpkgs;
      nixPath = (pkgs.lib.mapAttrsToList (name: _: "${name}=${inputs.${name}}") inputs);
      nixRegistry = pkgs.lib.mapAttrs (name: v: { flake = v; }) inputs;
    in
    import ./utils.nix {

      inherit self inputs utils;

      pkgs.nixpkgs.input = nixpkgs;

      pkgsConfig = {
        allowBroken = true;
        allowUnfree = true;
        oraclejdk.accept_license = true;
        permittedInsecurePackages = [ "openssl-1.0.2u" ];
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

      sharedModules =
        [
          home-manager.nixosModules.home-manager
          (import ./modules)
          {
            nix.extraOptions = "experimental-features = nix-command flakes";
            nix.nixPath = nixPath ++ [ "repl=${toString ./.}/repl.nix" ];
            nix.package = pkgs.nixUnstable;
            nix.registry = nixRegistry;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];


      nixosProfiles = {
        GytisOS.modules = [ (import ./configurations/GytisOS.host.nix) ];

        Morty.modules = [ (import ./configurations/Morty.host.nix) ];

        NixyServer.modules = [ (import ./configurations/NixyServer.host.nix) ];
      };


    };
}







