{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  systemd.user.services.nm-applet = {
    description = "Network Manager Applet";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
  };

}
