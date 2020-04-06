{ config, pkgs, lib, ... }:
{

	environment.systemPackages = with pkgs; [
		numix-gtk-theme
		papirus-icon-theme
	];

	environment.etc = {
		"xdg/gtk-3.0/settings.ini".source = ./settings.ini;
	};

}
