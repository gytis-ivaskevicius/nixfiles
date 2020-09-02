{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd ];

  environment.systemPackages = [
    pkgs.polybar
  ];

  systemd.user.services.polybar = {
    description = "Polybar system status bar";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.polybar}/bin/polybar -c ${./polybar.conf} main";
    };
  };

}
