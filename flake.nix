{
  description = "A highly awesome system configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    #unstable.url = github:nixos/nixpkgs;
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

    nixpkgs-mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };

    forgit-git = {
      url = github:wfxr/forgit;
      flake = false;
    };

  };

  outputs = inputs@{ self, utils, nur, home-manager, nixpkgs-mozilla, ... }:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      mkApp = utils.lib.mkApp;
      suites = import ./suites.nix { inherit utils; };
    in
    with suites.nixosModules;
    utils.lib.systemFlake {
      inherit self inputs;
      inherit (suites) nixosModules;


      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.config.replaceStdenv = { pkgs }: pkgs.gcc11Stdenv;
      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev:
          let
          in
          prev.lib.mapAttrs
            (_: v: v.override { stdenv = final.gcc10Stdenv; })
            {
              inherit (prev)
                aws-c-common
                libebml
                exempi
                llvmPackages_11
                llvmPackages_7
                s2n-tls
                eog
                tracker
                ;
       #                > Testing Time: 172.86s
       #>   Unsupported      :  1339
       #>   Passed           : 40495
       #>   Expectedly Failed:   145
       #>   Failed           :    78
       #>

              gtk3 = prev.gtk3.overrideAttrs (old: {
                mesonFlags = old.mesonFlags ++ ["-Dgtk:werror=false"];
                #configureFlags = old.configureFlags ++ [    "--disable-werror" ];
              });

            })
        #(final: prev: { inherit (channels.unstable) neovim-unwrapped linuxPackages_latest gcc11Stdenv; })
      ];

      hosts.GytisOS.modules = suites.desktopModules ++ [
        #aarch64Dev
        dev
        {
          security.apparmor.enable = true;
        }

        ./hosts/work.secret.nix
        ./hosts/GytisOS.host.nix
      ];

      hosts.Morty.modules = suites.desktopModules ++ [
        ./hosts/Morty.host.nix
      ];

      hosts.NixyServer.modules = [
        containers
        ./hosts/NixyServer.host.nix
      ];

      sharedOverlays = [
        (import nixpkgs-mozilla)
        self.overlay
        nur.overlay
        (final: prev: {
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


