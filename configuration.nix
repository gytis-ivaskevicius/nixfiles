{ config, pkgs, ... }:

{
  imports =
    [
      ./bundles/apps.nix
      ./bundles/base.nix
      ./bundles/clean_home.nix
      ./bundles/dev.nix
      ./bundles/i3rice.nix
      ./hardware-configuration.nix
      ./modules/cli
      ./modules/emacs
      ./modules/vim
      ./personal.nix
    ];


    environment.systemPackages = with pkgs; [

    ];

}
