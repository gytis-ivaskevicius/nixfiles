{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "guest";   # change this
    dataDir = "/home/guest/.config/syncthing";  # default location
    guiAddress = "127.0.0.1:8384";  # local web UI only
  };

  # Open firewall for Syncthing LAN discovery & transfer
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];
}

