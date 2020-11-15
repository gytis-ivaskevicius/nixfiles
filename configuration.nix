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
      ./personal.nix
    ];

    nixpkgs.overlays = [ (import ./pkgs) ];

    environment.systemPackages = with pkgs; [

    ];

}
