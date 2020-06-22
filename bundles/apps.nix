
{ config, pkgs, ... }:

{

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.gtkUsePortal = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.variables = {
      BROWSER = "brave";
      TERMINAL = "termite";
  };

  environment.systemPackages = with pkgs; [
      arandr
      brave
      discord
      firefox 
      gnome3.nautilus
      home-manager
      pavucontrol 
      vlc
  ];



}

