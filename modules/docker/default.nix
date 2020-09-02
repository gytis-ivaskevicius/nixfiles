{ config, lib, pkgs, ... }:
{
  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    enableNvidia = true;
    enableOnBoot = false;
  };

  environment.systemPackages = with pkgs; [
    docker_compose
  ];

}

