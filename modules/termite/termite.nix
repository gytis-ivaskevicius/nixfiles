{ config, pkgs, lib, ... }:
{
	environment.systemPackages = [ pkgs.termite ];

	environment.etc = {
		"xdg/termite/config".source = ./termite.conf;
	};
}
