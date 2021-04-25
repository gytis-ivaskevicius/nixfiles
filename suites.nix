{ utils }:
let
  nixosModules = utils.lib.modulesFromList [
    ./modules/cachix.nix
    ./modules/clean-home.nix
    ./modules/nix-compose.nix
    ./modules/runtimes.nix

    ./configurations/aarch64Dev.nix
    ./configurations/base-desktop.nix
    ./configurations/cli-extras.nix
    ./configurations/cli.nix
    ./configurations/containers.nix
    ./configurations/dev.nix
    ./configurations/personal.nix
    ./configurations/sway.nix
    ./configurations/xorg.nix
  ];
  sharedModules = with nixosModules; [
    cachix
    clean-home
    runtimes
    nix-compose
    personal

    utils.nixosModules.saneFlakeDefaults
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];
  desktopModules = with nixosModules; [
    base-desktop
    cli
    cli-extras
    sway
    ({ pkgs, ... }: {
      home-manager.users.gytis = import ./home-manager/sway.nix;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      nixpkgs.config.allowBroken = false;
    })
  ];
in
{
  inherit nixosModules sharedModules desktopModules;
}
