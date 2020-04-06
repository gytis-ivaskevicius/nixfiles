{ config, pkgs, lib, ... }:
{
	environment.systemPackages = [ pkgs.termite ];

	fonts.fonts = [ pkgs.nerdfonts ];
	environment.etc = {
		"xdg/termite/config".source = ./termite.conf;
	};
}
