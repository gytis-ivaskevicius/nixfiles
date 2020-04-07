{ config, pkgs, lib, ... }:
{

	boot = {
		cleanTmpDir = true;
		kernelPackages = pkgs.linuxPackages_latest;
		loader.systemd-boot.enable = true;
		tmpOnTmpfs = true;
	};

	i18n = {
		consoleFont = "Lat2-Terminus16";
		consoleKeyMap = "us";
		defaultLocale = "en_US.UTF-8";
	};


	nixpkgs.config = {
		allowUnfree = true;
		oraclejdk.accept_license = true;
	};

	nix.autoOptimiseStore = true;
	#powerManagement.powertop.enable = true; 
	system.stateVersion = "19.09";
	time.timeZone = "Europe/Vilnius";
	networking.networkmanager.enable = true;

	nix.gc = {
		automatic = true;
		options = "--delete-older-than 20d";
		dates = "Mon 12:00:00";
	};

	services = {
		avahi.enable = true; 
		avahi.nssmdns = true;
		printing.enable = true;
		tlp.enable = true; 
	};


	zramSwap = {
		enable = true;
		algorithm = "zstd";
	};

	hardware = {
		opengl = {
			enable = true;
			driSupport32Bit = true;
		};
		pulseaudio = {
			enable = true;
			support32Bit = true;
		};
		cpu.amd.updateMicrocode = true;
		cpu.intel.updateMicrocode = true;
	};



}
