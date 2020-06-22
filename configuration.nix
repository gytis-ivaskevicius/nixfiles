{ config, pkgs, ... }:

{
  imports =
    [
      /home/gytis/personal.nix
      ./bundles/base.nix
      ./bundles/i3rice.nix
      ./bundles/apps.nix
      ./hardware-configuration.nix
      ./modules/cli/cli.nix
      ./modules/runtimes/runtimes.nix
#      ./modules/virtualisation/docker.nix
#      ./modules/virtualisation/kubernetes.nix
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
  

  environment.systemPackages = with pkgs; [
      multimc
      cura

      gitkraken
      insomnia
      jetbrains.idea-community
      jetbrains.webstorm

      obs-studio
  ];



}
