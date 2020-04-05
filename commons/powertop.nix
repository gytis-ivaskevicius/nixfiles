{ config, pkgs, ... }:

{
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  environment.systemPackages = [ pkgs.powertop ];
}
