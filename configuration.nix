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
      ./modules/cli
      ./modules/vim
      ./personal.nix
    ];

    users.extraUsers.gytis = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Gytis Ivaskevicius";
      extraGroups = [ "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
      initialPassword = "toor";
    };

    environment.systemPackages = with pkgs; [

    ];

}
