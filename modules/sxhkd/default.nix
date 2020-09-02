{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd ];
      environment.systemPackages = [ pkgs.sxhkd pkgs.i3lock-pixeled ];


  systemd.user.services.sxhkd = {
    description = "Simple X hotkey daemon";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.sxhkd}/bin/sxhkd -c ${./sxhkd.conf}";
    };
  };

}
