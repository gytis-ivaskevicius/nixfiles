{ config, pkgs, ... }:

{
  imports =
    [
      ./zfs.nix
      ./bundles/apps.nix
      ./bundles/base.nix
      ./bundles/clean_home.nix
      ./bundles/dev.nix
      ./bundles/i3rice.nix
      ./hardware-configuration.nix
      ./modules/cli
      ./modules/vim
      ./personal.nix
    ];


    environment.systemPackages = with pkgs; [

    ];

}
