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
      jetbrains.webstorm
      jetbrains.idea-community
      gitkraken
      insomnia

      google-chrome
      firefox 
      discord
      gnome3.nautilus

      arandr
      autorandr
      mpv 
      obs-studio
      pavucontrol 
      steam 
      steam-run
      linux-steam-integration
      tlp
      vlc
      ];



}
