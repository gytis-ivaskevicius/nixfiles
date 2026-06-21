{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./modules/clean-home.nix

    ./config/aarch64Dev.nix
    ./config/base-desktop.nix
    ./config/dev.nix
    ./config/personal.nix
    ./config/winapps.nix
  ];
  sharedModules = with nixosModules; [
    #cachix
    clean-home
    personal

    #utils.nixosModules.saneFlakeDefaults
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];
  desktopModules = with nixosModules; [
    base-desktop
    winapps
    ({ pkgs, lib, config, ... }: {
      nix.generateRegistryFromInputs = true;
      nix.linkInputs = true;
      #nix.generateNixPathFromInputs = true;
      home-manager.users.gytis = {
        imports = [
          ./home-manager/common.nix
          ./home-manager/git.nix
          ./home-manager/cli.nix
          ./home-manager/alacritty.nix
        ];
      };
      home-manager.backupFileExtension = "HMBackup";
      #boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_5_15;
      #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
      #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      hardware.bluetooth.enable = true;
      nix.extraOptions = ''
        http-connections = 50
        log-lines = 50
        warn-dirty = false
        http2 = true
        allow-import-from-derivation = true
      '';
    })
  ];
in
{ inherit nixosModules sharedModules desktopModules; }
