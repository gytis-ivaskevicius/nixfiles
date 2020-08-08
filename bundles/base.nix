{ config, pkgs, lib, ... }:
{

	#powerManagement.powertop.enable = true; 
	console.font = "Lat2-Terminus16";
	console.keyMap = "us";
	fileSystems."/boot".label = "BOOT";
	i18n.defaultLocale = "en_US.UTF-8";
	nix.autoOptimiseStore = true;
	nix.maxJobs = 16;
	system.stateVersion = "20.03";
	time.timeZone = "Europe/Vilnius";
	systemd.extraConfig = "DefaultMemoryAccounting=yes";

	nixpkgs.config = {
		allowUnfree = true;
		oraclejdk.accept_license = true;
	};

	networking = {
	    nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
	    firewall.allowPing = false;
	    networkmanager.enable = true;
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
