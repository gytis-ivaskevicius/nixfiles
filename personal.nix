################################################
# Untracked system specific configuration file #
################################################

{ config, pkgs, lib, ... }:

{
  imports = [

  ];

  networking.hostName = "GytisOS";

  #boot.kernelPackages = pkgs.linuxPackages_latest;   # Default value is 'pkgs.linuxPackages'
  #hardware.bluetooth.enable = true;                  # Default value is 'false'
  #services.openssh.passwordAuthentication = false;   # Default value is 'false'
  services.zerotierone.enable = true;                # Default value is 'false'
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" ];           # Default value is '[]'
  #time.timeZone = "Europe/Vilnius";                  # Default value is 'Europe/Vilnius'
  #networking.enableIPv6 = false;                     # Default value is 'true'

  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [
    cachix

  ];

  networking.extraHosts = ''

  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  nix = {
    extraOptions = "gc-keep-outputs = true";

    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://gytix.cachix.org/"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "gytix.cachix.org-1:JXNZBxYslCV/hAkfNvJgyxlWb8jRQRKc+M0h7AaFg7Y="
    ];
  };
}
