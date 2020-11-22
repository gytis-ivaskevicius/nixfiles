
{ config, pkgs, ... }:

{
  imports = [
    ../modules/compton
    ../modules/i3
    ../modules/styling
  ];

  gytix.ui.autorandr.enable = true;
  gytix.ui.feh.enable = true;
  gytix.ui.flameshot.enable = true;
  gytix.ui.nm-applet.enable = true;
  gytix.ui.polkit-ui.enable = true;
  gytix.ui.polybar.enable = true;
  gytix.ui.sxhkd.enable = true;
  gytix.ui.ulauncher.enable = true;

}
