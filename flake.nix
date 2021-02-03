{
  description = "A highly awesome system configuration.";

  inputs = {
    master.url = "nixpkgs/master";
    nixpkgs.url = "nixpkgs/release-20.09";

    home-manager = { url = github:nix-community/home-manager/release-20.09; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly-overlay = { url = github:nix-community/neovim-nightly-overlay; inputs.nixpkgs.follows = "master"; };
    nixpkgs-mozilla = { url = github:mozilla/nixpkgs-mozilla; flake = false; };

  };

  outputs = inputs@{ self, neovim-nightly-overlay, home-manager, nixpkgs-mozilla, nixpkgs, master, ... }:
    let
      inherit (nixpkgs) lib;
      inherit (lib) recursiveUpdate;
      system = "x86_64-linux";
      my-pkgs = import ./overlays;

      utils = import ./utility-functions.nix {
        inherit lib system pkgs inputs self;
        nixosModules = self.nixosModules;
      };

      unstable-pkgs = import master {
        inherit system;
        config = {
          allowUnfree = true;
          oraclejdk.accept_license = true;
        };
      };
      #unstable-pkgs = utils.pkgImport master [ my-pkgs ];


      tmp-pkgs = (import nixpkgs { inherit system; }).pkgs;
      nixpkgs-patched = tmp-pkgs.applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = [
          (tmp-pkgs.fetchpatch {
            url = "https://github.com/NixOS/nixpkgs/pull/93832/commits/20fa0c5949604671e200062dff009516e4d8ae84.patch";
            sha256 = "sha256-3gmtPyPgeVmF4CGdHm+ht088A++saGeeu/TBtkzypro=";
          })
        ];
      };
      #  pkgs = utils.pkgImport nixpkgs self.overlays;
      pkgs = utils.pkgImport nixpkgs-patched self.overlays;
      cleanNixpkg = (import nixpkgs { inherit system; });


    in
    {
      nixosModules = [
        home-manager.nixosModules.home-manager
        (import ./modules)
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      nixosConfigurations = utils.buildNixosConfigurations [
        ./configurations/GytisOS.host.nix
      ];

      overlay = my-pkgs;
      overlays = [
        (import nixpkgs-mozilla)
        neovim-nightly-overlay.overlay
        my-pkgs
        (final: prev:
          with prev;
          let
            gccArgs = { stdenv = gccStdenv; };
            useGcc = pkg: pkg.override gccArgs;
          in
           {

            # gcc not found or libc is fucked
            busybox = useGcc busybox;
            dmidecode = useGcc dmidecode;
            elfutils = useGcc elfutils;
            lm_sensors = useGcc lm_sensors;
            p7zip = useGcc p7zip;
            iproute = useGcc iproute;
            glibcLocales = useGcc glibcLocales;


            #libpaper = useGcc libpaper;
            #boehm-gc = useGcc boehm-gc;

            # unknown options
            libfaketime = useGcc libfaketime;

            python = useGcc python;
            python27 = useGcc python27;
            python27Packages = useGcc python27Packages;

            python3  = useGcc python3;
            python36 = useGcc python36;
            python37 = useGcc python37;
            python38 = useGcc python38;
            python39 = useGcc python39;

            python37Packages = useGcc python37Packages;
            python38Packages = useGcc python38Packages;
            python39Packages = useGcc python39Packages;

            lua = useGcc lua;

            lua51Packages = useGcc lua53Packages;
            lua52Packages = useGcc lua53Packages;
            lua53Packages = useGcc lua53Packages;

            lua5_1 = useGcc lua5_3;
            lua5_2 = useGcc lua5_3;
            lua5_3 = useGcc lua5_3;

            lua5_1_compat = useGcc lua5_3_compat;
            lua5_2_compat = useGcc lua5_3_compat;
            lua5_3_compat = useGcc lua5_3_compat;

            luajit_2_0 = useGcc luajit_2_0;
            luajit_2_1 = useGcc luajit_2_1;

            # Compilation error, linkers, etc
            #pkg-config = useGcc pkg-config;
            cyrus_sasl = useGcc cyrus_sasl;
            mpg123 = useGcc mpg123;
            cpio = useGcc cpio;
            gnum4 = prev.gnum4.override { stdenv = cleanNixpkg.stdenv; };
            kexectools = useGcc kexectools;
            keyutils = useGcc keyutils;
            libnftnl = useGcc libnftnl;
            libomxil-bellagio = useGcc libomxil-bellagio;
            libvorbis = useGcc libvorbis;
            pixman = useGcc pixman;

#            llvm =  cleanNixpkg.llvm.override {
#              cmake = cleanNixpkg.cmake;
#              stdenv = cleanNixpkg.stdenv;
#            };
          })
        (final: prev: {
          inherit (unstable-pkgs) manix alacritty jetbrains firefox jdk15 brave gitkraken gradle insomnia maven linuxPackages_latest;
          unstable = unstable-pkgs;
        })

      ];

      packages."${system}" = (my-pkgs null pkgs);
    };
}
