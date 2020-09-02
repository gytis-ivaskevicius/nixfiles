{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd ];
  environment.systemPackages = with pkgs; [networkmanagerapplet];


  systemd.user.services.nm-applet = {
    description = "Network Manager Applet";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
  };

}
