{ config, pkgs, ... }:

{
  imports =
    [
      ./bundles/apps.nix
      ./bundles/base.nix
      ./bundles/clean_home.nix
      ./bundles/dev.nix
      ./bundles/i3rice.nix
      ./hardware-configuration.nix
      ./modules/cli/cli.nix
      ./modules/emacs/emacs.nix
      ./modules/runtimes/runtimes.nix
      ./modules/virtualisation/docker.nix
      ./modules/virtualisation/minikube.nix
#      ./modules/virtualisation/virtualbox.nix
      /home/gytis/personal.nix
    ];

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
    uid = 1000;
  };
  

  environment.systemPackages = with pkgs; [

  ];

}
