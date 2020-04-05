{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  systemd.user.services.ulauncher = {
    description = "Ulauncher";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher";
    };
  };

}
