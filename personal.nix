################################################
# Untracked system specific configuration file #
################################################

{ config, pkgs, lib, ... }:

{
  imports = [

  ];

  networking.hostName = "GytisOS";
  #boot.kernelPackages = pkgs.linuxPackages_latest;   # Default value is 'pkgs.linuxPackages'
  #services.openssh.passwordAuthentication = false;   # Default value is 'false'
  #time.timeZone = "Europe/Vilnius";                  # Default value is 'Europe/Vilnius'

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

}
