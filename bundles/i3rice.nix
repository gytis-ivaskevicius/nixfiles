
{ config, pkgs, ... }:

{
  imports =
    [
      ../modules/compton/compton2.nix
      ../modules/feh/feh.nix
      ../modules/fonts/fonts.nix
      ../modules/i3/i3.nix
      ../modules/nm-applet/nm-applet.nix
      ../modules/polkit-ui/polkit-ui.nix
      ../modules/polybar/polybar.nix
      ../modules/sxhkd/sxhkd.nix
      ../modules/termite/termite.nix
      ../modules/ulauncher/ulauncher.nix
    ];

  }
