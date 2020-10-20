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
  #services.zerotierone.enable = true;                # Default value is 'false'
  #services.zerotierone.joinNetworks = [ ];           # Default value is '[]'
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

  ];

  networking.extraHosts = ''

  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

}
