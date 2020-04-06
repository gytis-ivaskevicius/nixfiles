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
  xdg.mime.enable = true;
services.xserver.displayManager.lightdm.enable = true;
services.xserver.displayManager.lightdm.greeters.enso.enable = true;
services.xserver.displayManager.lightdm.greeters.enso.theme.name = "Numix";
services.xserver.displayManager.lightdm.greeters.enso.theme.package = pkgs.numix-gtk-theme;

#services.xserver.displayManager.lightdm.background
#services.xserver.displayManager.lightdm.greeters.enso.blur
#services.xserver.displayManager.lightdm.greeters.enso.brightness
#services.xserver.displayManager.lightdm.greeters.enso.cursorTheme.name
#services.xserver.displayManager.lightdm.greeters.enso.cursorTheme.package

#services.xserver.displayManager.lightdm.greeters.enso.extraConfig
#services.xserver.displayManager.lightdm.greeters.enso.iconTheme.name
#services.xserver.displayManager.lightdm.greeters.enso.iconTheme.package

  environment.systemPackages = with pkgs; [
      lightlocker
      wmctrl
      xclip
      xdotool
  ];


}
