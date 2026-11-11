{
  description = "A highly awesome system configuration.";

  inputs = {
    #nixpkgs.url = "/home/gytis/nixpkgs/";
    #unstable.url = "/home/gytis/nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsLayan.url = "github:NixOS/nixpkgs/7fb43cc4bec0d7635316114b07aebb0d0f610d03";


    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Pinned to a release tag on purpose: the Nix build runs npm with
    # --ignore-scripts, so patch-package's patches get skipped and the web UI
    # crashes with React error #130 (getpaseo/paseo#7673). The overlay below
    # re-runs `npm run postinstall` to apply them.
    # Own nixpkgs, not `follows`: the release's npmDepsHash only matches the
    # nixpkgs it was built against.
    paseo.url = "github:getpaseo/paseo/v0.15.0";

    maki.url = "github:tontinton/maki";
    maki.inputs.nixpkgs.follows = "nixpkgs";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    #utils.url = "/home/gytis/Projects/flake-utils-plus";

    nix2vim.url = "/home/gytis/Projects/NIX/nix2vim";
    #nix2vim.url = "github:gytis-ivaskevicius/nix2vim";
    nix2vim.inputs.nixpkgs.follows = "";
    nix2vim.inputs.flake-utils.follows = "utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

          gtk-engine-murrine =
            final.callPackage "${inputs.nixpkgsLayan.outPath}/pkgs/by-name/gt/gtk-engine-murrine/package.nix" { };
          layan-gtk-theme =
            final.callPackage "${inputs.nixpkgsLayan.outPath}/pkgs/by-name/la/layan-gtk-theme/package.nix" { };
        })
        (final: prev:
          let
            upstream = inputs.paseo.packages.${final.stdenv.hostPlatform.system};
            # Upstream's nix/npm-deps.hash doesn't match what fetchNpmDeps produces
            # for this lockfile, and the desktop package inherits paseo's npmDeps,
            # so both are rebuilt from the one corrected hash.
            paseo = upstream.default.override {
              npmDepsHash = "sha256-YLrbUckIiyV7esu2tmiKdLL0YHsvwqcA0Xe0gSeMCC0=";
            };
          in
          {
            inherit paseo;
            paseo-desktop = (final.callPackage "${inputs.paseo}/nix/desktop-package.nix" {
              inherit paseo;
              buildVersion = "0.15.0";
            }).overrideAttrs {
              preBuild = "npm run postinstall";
              # Nix owns the install; the updater must not try to replace it.
              postPatch = ''
                substituteInPlace packages/desktop/src/features/auto-updater.ts \
                  --replace-fail 'isPackaged: () => app.isPackaged,' 'isPackaged: () => false,'
              '';
            };
          })
        # maki reads its Opencode key from the env, so keep the one key where
        # opencode already stores it instead of copying it into the store.
        (final: prev: {
          maki = prev.writeShellScriptBin "maki" ''
            export OPENCODE_API_KEY="''${OPENCODE_API_KEY:-$(\
              ${prev.jq}/bin/jq -r .opencode.key "''${XDG_DATA_HOME:-$HOME/.local/share}/opencode/auth.json")}"
            exec ${inputs.maki.packages.${final.stdenv.hostPlatform.system}.default}/bin/maki "$@"
          '';
        })
      ];


      hosts.Monday.modules = suites.desktopModules ++ [
        aarch64Dev
        dev
        ./hosts/Monday.host.nix
        ./config/syncthing.nix
        ./config/paseo.nix
        inputs.paseo.nixosModules.paseo
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-cpu-amd-zenpower
        #./config/k3s.nix

      ];

      sharedOverlays = [
        self.overlay
        nix2vim.overlay
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

