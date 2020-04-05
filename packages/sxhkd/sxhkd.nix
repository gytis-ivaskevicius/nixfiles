{ config, pkgs, lib, ... }:
{
  imports = [ ../base-systemd/applicationsTarget.nix ];

  systemd.user.services.sxhkd = {
    description = "Simple X hotkey daemon";
    wantedBy = ["applications.target"];
    serviceConfig = {
      Restart = "always";
#      ExecStart = "/run/current-system/sw/bin/echo $PATH";
      ExecStart = "/bin/sh -c \"${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}\"";
    };
  };

}
