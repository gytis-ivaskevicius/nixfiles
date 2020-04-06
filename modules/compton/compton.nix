{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];

  systemd.user.services.compton = {
    description = "Compton compositor";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.compton}/bin/compton --config {./compton.conf}";
    };
  };

}
