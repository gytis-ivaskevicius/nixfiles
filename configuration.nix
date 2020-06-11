{ config, pkgs, ... }:

{
  imports =
    [
      /home/gytis/personal.nix
      ./bundles/base.nix
      ./bundles/i3rice.nix
      ./hardware-configuration.nix
      ./modules/cli/cli.nix
      ./modules/runtimes/runtimes.nix
      ./modules/virtualisation/docker.nix
#      ./modules/virtualisation/virtualbox.nix
    ];

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
    uid = 1000;
  };
  
services.flatpak.enable = true;
xdg.portal.enable = true;
xdg.portal.gtkUsePortal = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  environment.systemPackages = with pkgs; [
      multimc
      home-manager
      cura
      kdeApplications.kdenlive

      gitkraken
      insomnia
      jetbrains.idea-community
      jetbrains.webstorm

      discord
      brave
      firefox 
      gnome3.nautilus
      google-chrome
      obs-studio
      vlc
      arandr
      pavucontrol 
      ];



}
