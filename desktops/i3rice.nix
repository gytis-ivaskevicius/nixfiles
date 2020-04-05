
{ config, pkgs, ... }:

{
  imports =
    [
      ../packages/compton/compton2.nix
      ../packages/feh/feh.nix
      ../packages/drivers/drivers.nix
      ../packages/i3/i3.nix
      ../packages/nm-applet/nm-applet.nix
      ../packages/polkit-ui/polkit-ui.nix
      ../packages/polybar/polybar.nix
      ../packages/sxhkd/sxhkd.nix
      ../packages/ulauncher/ulauncher.nix
    ];

  }
