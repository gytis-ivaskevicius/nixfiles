{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd/autostart-systemd.nix ];
  environment.systemPackages = [ pkgs.autorandr ];


  systemd.user.services.autorandr = {
    description = "Autorandr execution hook";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.autorandr}/bin/autorandr --change";
    };
  };

}
