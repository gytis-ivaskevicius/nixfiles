{ config, lib, pkgs, ... }:

{
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = [ pkgs.i3lock ];

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.libinput.enable = true;

  services.xserver.windowManager.i3.configFile = ./i3config;
}
