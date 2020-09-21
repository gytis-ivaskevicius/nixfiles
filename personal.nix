##############################################
# Untracked system specific configuration file
##############################################

{ config, pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [

  ];

  networking.extraHosts = ''

  '';

}
