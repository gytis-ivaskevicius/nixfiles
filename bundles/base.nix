{ config, pkgs, lib, ... }:
{

	nix.maxJobs = 8;
	nix.autoOptimiseStore = true;
	#powerManagement.powertop.enable = true; 
	system.stateVersion = "19.09";
	time.timeZone = "Europe/Vilnius";
	networking.networkmanager.enable = true;
	networking.firewall.allowPing = false;
	fileSystems."/boot".label = "BOOT";

	nixpkgs.config = {
		allowUnfree = true;
		oraclejdk.accept_license = true;
	};

	nix.gc = {
		automatic = true;
		options = "--delete-older-than 20d";
		dates = "Mon 12:00:00";
	};

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


	services = {
		avahi.enable = true; 
		avahi.nssmdns = true;
		logind.killUserProcesses = true;
		openssh.enable = true;
		openssh.passwordAuthentication = false;
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
		bluetooth.enable = false;
		cpu.amd.updateMicrocode = true;
		cpu.intel.updateMicrocode = true;
	};

}
