{ config, pkgs, lib, ... }:

with lib;
let cfg = config.gytix.cachix;
in {
  options = {
    gytix.cachix.enable = mkEnableOption "Enable custom cachix configuration";
  };

  config = mkIf cfg.enable {

    #environment.systemPackages = with pkgs; [ cachix ];

    nix.extraOptions = "gc-keep-outputs = true";
    nix.settings = {
      substituters = [
        "https://cache.iog.io"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };
}
