################################################
# Untracked system specific configuration file #
################################################

{ config, pkgs, ... }:

{
  imports = [

  ];

  networking.hostName = "GytisOS";
  boot.kernelPackages = pkgs.linuxPackages_latest;   # Default value is 'pkgs.linuxPackages'
  #services.openssh.passwordAuthentication = false;   # Default value is 'false'
  #time.timeZone = "Europe/Vilnius";                  # Default value is 'Europe/Vilnius'
  #boot.tmpOnTmpfs = false;                           # Default value is 'false'

  environment.systemPackages = with pkgs; [

  ];

  networking.extraHosts = ''

  '';

}
