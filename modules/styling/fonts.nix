{ config, pkgs, lib, ... }:
{


	fonts = {
		fontconfig.enable = true;
		enableFontDir = true;
		enableGhostscriptFonts = true;
		fonts = with pkgs; [
				dejavu_fonts
				ubuntu_font_family
				source-code-pro
				noto-fonts
				noto-fonts-extra
				noto-fonts-cjk
				noto-fonts-emoji
				fira-code
				fira-code-symbols
				nerdfonts
				];


		fontconfig.defaultFonts = {
			monospace = ["RobotoMono Nerd Font" "DejaVu Sans Mono" ];
			sansSerif = [ "Roboto" "DejaVu Sans" ];
			serif =  		[ "Roboto" "DejaVu Serif" ];    };
	};


	console.earlySetup = true;

#fonts.fontconfig.defaultFonts.emoji
}
