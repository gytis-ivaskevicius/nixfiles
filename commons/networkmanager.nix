{  config, pkgs, ...}:

{
#	services.unbound.enable = true;
	networking.networkmanager.enable = true;
	networking.hostName = "gytis-os";
}
