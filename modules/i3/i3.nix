{ config, lib, pkgs, ... }:

{
	environment.etc = {
		"i3/autotiling.sh".source = ./autotiling.sh;
	};
	xdg.mime.enable = true;

	services.xserver = {

		enable = true;
		layout = "us";
		xkbOptions = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
		libinput.enable = true;

		displayManager.lightdm = {
			enable = true;
			greeters.enso.enable = true;
			greeters.enso.theme.name = "Numix";
			greeters.enso.theme.package = pkgs.numix-gtk-theme;

#			background
#			greeters.enso.blur
#			greeters.enso.brightness
#			greeters.enso.cursorTheme.name
#			greeters.enso.cursorTheme.package
#							  
#			greeters.enso.extraConfig
#			greeters.enso.iconTheme.name
#			greeters.enso.iconTheme.package

		};

		windowManager.i3 = {
			enable = true;
			configFile = ./i3config;
			extraPackages = [ pkgs.i3lock ];                                 	
			extraSessionCommands = "systemd --user restart autostart.target";
			package = pkgs.i3-gaps;
		};
	};

	environment.systemPackages = with pkgs; [
		lightlocker
		wmctrl
		xclip
		xdotool
	];

}
