{ config, lib, pkgs, ... }:
{
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableOnBoot = false;
    liveRestore = false;
  };
}

