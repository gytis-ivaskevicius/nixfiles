{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];
      environment.systemPackages = [ pkgs.sxhkd ];


  systemd.user.services.sxhkd = {
    description = "Simple X hotkey daemon";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
#      ExecStart = "/run/current-system/sw/bin/echo $PATH";
      ExecStart = "/bin/sh -c \"${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}\"";
    };
  };

}
