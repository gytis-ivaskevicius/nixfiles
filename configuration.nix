{ config, pkgs, ... }:

{
  imports =
    [
      ./bundles/base.nix
      ./bundles/i3rice.nix
      ./hardware-configuration.nix
      ./modules/cli/cli.nix
      ./modules/runtimes/runtimes.nix
      ./modules/virtualisation/docker.nix
      ./modules/virtualisation/virtualbox.nix
    ];

  services.openssh.enable = false;

  users.extraUsers.gytis = {
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
    uid = 1000;
  };


  environment.systemPackages = with pkgs; [
      home-manager

      gitkraken
      insomnia
      jetbrains.idea-community
      jetbrains.webstorm

      discord
      firefox 
      gnome3.nautilus
      google-chrome
      obs-studio
      vlc

      linux-steam-integration
      steam 
      steam-run

      arandr
      pavucontrol 
      ];



}
