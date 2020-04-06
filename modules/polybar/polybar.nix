{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  environment.systemPackages = [
    pkgs.polybar
    pkgs.nerdfonts 
  ];

  systemd.user.services.polybar = {
    description = "Polybar system status bar";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.polybar}/bin/polybar -c ${./polybar.conf} main";
    };
  };

}
