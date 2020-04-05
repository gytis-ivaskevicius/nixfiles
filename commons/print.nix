{ config, lib, pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cups pkgs.ghostscript pkgs.hplip pkgs.splix pkgs.samsungUnifiedLinuxDriver pkgs.gutenprintBin ];

  services.avahi.enable = true; # sometimes needed for finding on network
  services.avahi.nssmdns = true;
}
