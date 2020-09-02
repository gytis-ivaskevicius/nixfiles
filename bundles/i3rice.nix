
{ config, pkgs, ... }:

{
  imports =
    [
      ../modules/compton
      ../modules/dunst
      ../modules/feh
      ../modules/autorandr
      ../modules/flameshot
      ../modules/i3
      ../modules/nm-applet
      ../modules/polkit-ui
      ../modules/polybar
      ../modules/styling/fonts.nix
      ../modules/styling/theme.nix
      ../modules/sxhkd
      ../modules/termite
      ../modules/ulauncher
    ];

  }
