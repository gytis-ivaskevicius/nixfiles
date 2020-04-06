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
      arandr
      autorandr
      discord
      flameshot
      gnome3.nautilus
      lightdm
      mplayer firefox 
      mpv 
      numix-gtk-theme
      obs-studio
      papirus-icon-theme
      pavucontrol 
      ranger
      steam 
      steam-run
      linux-steam-integration
      tlp
      vlc
      wmctrl
      xclip
      xdotool
      ];



}
