{ config, lib, pkgs, ... }:
{
	virtualisation.virtualbox.host = {
		enableExtensionPack = true;
		enable = true;
	};
}

