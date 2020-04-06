{ config, lib, pkgs, ... }:

{
  services.xserver.windowManager.i3.configFile = ./i3config;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = [ pkgs.i3lock ];
  services.xserver.windowManager.i3.extraSessionCommands = "systemd --user restart autostart.target";
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp;caps:escape;altwin:swap_alt_win";
  services.xserver.libinput.enable = true;

}
