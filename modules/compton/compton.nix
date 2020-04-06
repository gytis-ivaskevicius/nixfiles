{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  systemd.user.services.compton = {
    description = "Compton compositor";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.compton}/bin/compton --config {./compton.conf}";
    };
  };

}
