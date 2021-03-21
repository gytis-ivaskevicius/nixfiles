{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gytix.cachix;
in
{
  options = {
    gytix.cachix.enable = mkEnableOption "Enable custom cachix configuration";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ cachix ];

    nix = {
      extraOptions = "gc-keep-outputs = true";

      binaryCaches = [
        "https://cachix.cachix.org"
        "https://gytix.cachix.org/"
        "https://vitality.cachix.org/"
        "https://jrestivo.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      binaryCachePublicKeys = [
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "gytix.cachix.org-1:JXNZBxYslCV/hAkfNvJgyxlWb8jRQRKc+M0h7AaFg7Y="
        "jrestivo.cachix.org-1:+jSOsXAAOEjs+DLkybZGQEEIbPG7gsKW1hPwseu03OE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vitality.cachix.org-1:3EQptE4KeHbpTzbu/O/K6wi6XdOJThVyvrPEGS47+bs="
      ];
    };
  };
}
