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

    #environment.systemPackages = with pkgs; [ cachix ];

    nix = {
      extraOptions = "gc-keep-outputs = true";

      binaryCaches = [
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      binaryCachePublicKeys = [
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
