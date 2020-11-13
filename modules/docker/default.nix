{ config, lib, pkgs, ... }:
{
  virtualisation.docker = {
    autoPrune.enable = true;
    liveRestore = false;
    enable = true;
    enableNvidia = true;
    enableOnBoot = lib.mkDefault false;
  };

  environment.systemPackages = with pkgs; [
    docker_compose
  ];

}

